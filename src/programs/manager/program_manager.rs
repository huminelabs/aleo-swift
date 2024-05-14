use crate::{RPrivateKey, RProvingKey, RRecordPlaintext, RStringMap, RVerifyingKey};

use crate::types::native::{
    CurrentAleo, IdentifierNative, ProcessNative, ProgramIDNative, ProgramNative, ProvingKeyNative,
    QueryNative, RecordPlaintextNative, TransactionNative, VerifyingKeyNative,
};
use std::str::FromStr;

use core::ops::Add;

use crate::{execute_fee, execute_program, process_inputs, RTransaction};

use rand::{rngs::StdRng, SeedableRng};

#[swift_bridge::bridge]
pub mod ffi_program_manager {
    extern "Rust" {
        type RProgramManager;

        #[swift_bridge(already_declared)]
        type RPrivateKey;
        #[swift_bridge(already_declared)]
        type RProvingKey;
        #[swift_bridge(already_declared)]
        type RVerifyingKey;
        #[swift_bridge(already_declared)]
        type RRecordPlaintext;
        #[swift_bridge(already_declared)]
        type RTransaction;

        #[swift_bridge(already_declared)]
        type RStringMap;

        #[swift_bridge(associated_to = RProgramManager)]
        pub fn r_execute(
            private_key: &RPrivateKey,
            program: &str,
            function: &str,
            inputs: Vec<String>,
            fee_credits: f64,
            fee_record: Option<RRecordPlaintext>,
            url: Option<String>,
            imports: Option<RStringMap>,
            proving_key: Option<RProvingKey>,
            verifying_key: Option<RVerifyingKey>,
            fee_proving_key: Option<RProvingKey>,
            fee_verifying_key: Option<RVerifyingKey>,
        ) -> Option<RTransaction>;
    }
}

#[derive(Clone)]
pub struct RProgramManager;

impl RProgramManager {
    pub fn r_execute(
        private_key: &RPrivateKey,
        program: &str,
        function: &str,
        inputs: Vec<String>,
        fee_credits: f64,
        fee_record: Option<RRecordPlaintext>,
        url: Option<String>,
        imports: Option<RStringMap>,
        proving_key: Option<RProvingKey>,
        verifying_key: Option<RVerifyingKey>,
        fee_proving_key: Option<RProvingKey>,
        fee_verifying_key: Option<RVerifyingKey>,
    ) -> Option<RTransaction> {
        let r = || {
            Self::execute(
                private_key,
                program,
                function,
                inputs,
                fee_credits,
                fee_record,
                url,
                imports,
                proving_key,
                verifying_key,
                fee_proving_key,
                fee_verifying_key,
            )
        };

        let result = r();

        match result {
            Ok(transaction) => Some(transaction),
            Err(_) => None,
        }
    }

    pub fn execute(
        private_key: &RPrivateKey,
        program: &str,
        function: &str,
        inputs: Vec<String>,
        fee_credits: f64,
        fee_record: Option<RRecordPlaintext>,
        url: Option<String>,
        imports: Option<RStringMap>,
        proving_key: Option<RProvingKey>,
        verifying_key: Option<RVerifyingKey>,
        fee_proving_key: Option<RProvingKey>,
        fee_verifying_key: Option<RVerifyingKey>,
    ) -> Result<RTransaction, String> {
        // log(&format!("Executing function: {function} on-chain"));
        let fee_microcredits = match &fee_record {
            Some(fee_record) => Self::validate_amount(fee_credits, fee_record, true)?,
            None => (fee_credits * 1_000_000.0) as u64,
        };
        let mut process_native = ProcessNative::load_web().map_err(|err| err.to_string())?;
        let process = &mut process_native;
        const DEFAULT_URL: &str = "https://api.explorer.aleo.org/v1/testnet3";
        let node_url = url.as_deref().unwrap_or(DEFAULT_URL);

        // log("Check program imports are valid and add them to the process");
        let program_native = ProgramNative::from_str(program).map_err(|e| e.to_string())?;
        Self::resolve_imports(process, &program_native, imports)?;
        let rng = &mut StdRng::from_entropy();

        // log("Executing program");
        let (_, mut trace) = execute_program!(
            process,
            process_inputs!(inputs),
            program,
            function,
            private_key,
            proving_key,
            verifying_key,
            rng
        );

        // log("Preparing inclusion proofs for execution");
        let query = QueryNative::from(node_url);
        trace.prepare(query).map_err(|err| err.to_string())?;

        // log("Proving execution");
        let program = ProgramNative::from_str(program).map_err(|err| err.to_string())?;
        let locator = program.id().to_string().add("/").add(function);
        let execution = trace
            .prove_execution::<CurrentAleo, _>(&locator, &mut StdRng::from_entropy())
            .map_err(|e| e.to_string())?;
        let execution_id = execution.to_execution_id().map_err(|e| e.to_string())?;

        // log("Executing fee");
        let fee = execute_fee!(
            process,
            private_key,
            fee_record,
            fee_microcredits,
            node_url,
            fee_proving_key,
            fee_verifying_key,
            execution_id,
            rng
        );

        // Verify the execution
        process
            .verify_execution(&execution)
            .map_err(|err| err.to_string())?;

        // log("Creating execution transaction");
        let transaction = TransactionNative::from_execution(execution, Some(fee))
            .map_err(|err| err.to_string())?;
        Ok(RTransaction::from(transaction))
    }

    /// Check if a process contains a keypair for a specific function
    pub(crate) fn contains_key(
        process: &ProcessNative,
        program_id: &ProgramIDNative,
        function_id: &IdentifierNative,
    ) -> bool {
        process.get_stack(program_id).map_or_else(
            |_| false,
            |stack| {
                stack.contains_proving_key(function_id) && stack.contains_verifying_key(function_id)
            },
        )
    }

    /// Resolve imports for a program in depth first search order
    pub(crate) fn resolve_imports(
        process: &mut ProcessNative,
        program: &ProgramNative,
        imports: Option<RStringMap>,
    ) -> Result<(), String> {
        if let Some(imports) = imports {
            program.imports().keys().try_for_each(|program_id| {
                // Get the program string
                let program_id = program_id.to_string();
                if let Some(import_string) = imports.r_get(&program_id) {
                    if &program_id != "credits.aleo" {
                        let import = ProgramNative::from_str(&import_string)
                            .map_err(|err| err.to_string())?;
                        // If the program has imports, add them
                        Self::resolve_imports(process, &import, Some(imports.clone()))?;
                        // If the process does not already contain the program, add it
                        if !process.contains_program(import.id()) {
                            process
                                .add_program(&import)
                                .map_err(|err| err.to_string())?;
                        }
                    }
                }
                Ok::<(), String>(())
            })
        } else {
            Ok(())
        }
    }

    /// Validate that an amount being paid from a record is greater than zero and that the record
    /// has enough credits to pay the amount
    pub(crate) fn validate_amount(
        credits: f64,
        amount: &RRecordPlaintext,
        fee: bool,
    ) -> Result<u64, String> {
        let name = if fee { "Fee" } else { "Amount" };

        if credits <= 0.0 {
            return Err(format!(
                "{name} must be greater than zero to deploy or execute a program"
            ));
        }
        let microcredits = (credits * 1_000_000.0f64) as u64;
        if amount.r_microcredits() < microcredits {
            return Err(format!(
                "{name} record does not have enough credits to pay the specified fee"
            ));
        }

        Ok(microcredits)
    }
}
