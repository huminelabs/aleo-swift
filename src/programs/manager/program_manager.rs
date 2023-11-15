// use crate::{RPrivateKey, RProvingKey, RRecordPlaintext, RVerifyingKey};

// use crate::types::native::{
//     CurrentAleo, IdentifierNative, ProcessNative, ProgramIDNative, ProgramNative, ProvingKeyNative,
//     QueryNative, RecordPlaintextNative, TransactionNative, VerifyingKeyNative,
// };
// use std::collections::HashMap;
// use std::str::FromStr;

// use core::ops::Add;
// use std::sync::Arc;

// use crate::{execute_fee, execute_program, process_inputs, RTransaction};

// use futures::lock::Mutex;
// use rand::{rngs::StdRng, SeedableRng};

// #[swift_bridge::bridge]
// pub mod ffi_program_manager {
//     extern "Rust" {
//         type RProgramManager;
//         type RHashMapStrings;
//         type RKVPair;

//         #[swift_bridge(already_declared)]
//         type RPrivateKey;
//         #[swift_bridge(already_declared)]
//         type RProvingKey;
//         #[swift_bridge(already_declared)]
//         type RVerifyingKey;
//         #[swift_bridge(already_declared)]
//         type RRecordPlaintext;
//         #[swift_bridge(already_declared)]
//         type RTransaction;

//         #[swift_bridge(associated_to = RProgramManager)]
//         pub fn r_execute(
//             private_key: &RPrivateKey,
//             program: &str,
//             function: &str,
//             inputs: Vec<String>,
//             fee_credits: f64,
//             fee_record: Option<RRecordPlaintext>,
//             url: Option<String>,
//             imports: Option<RHashMapStrings>,
//             proving_key: Option<RProvingKey>,
//             verifying_key: Option<RVerifyingKey>,
//             fee_proving_key: Option<RProvingKey>,
//             fee_verifying_key: Option<RVerifyingKey>,
//         ) -> Option<RTransaction>;

//         #[swift_bridge(init, associated_to = RHashMapStrings)]
//         pub fn r_new(vector: Vec<RKVPair>) -> RHashMapStrings;

//         #[swift_bridge(init, associated_to = RKVPair)]
//         pub fn r_new(key: String, value: String) -> RKVPair;
//     }
// }

// #[derive(Clone)]
// pub struct RProgramManager;

// pub struct RHashMapStrings(HashMap<String, String>);
// pub struct RKVPair {
//     key: String,
//     value: String,
// }

// impl RProgramManager {
//     pub fn r_execute(
//         private_key: &RPrivateKey,
//         program: &str,
//         function: &str,
//         inputs: Vec<String>,
//         fee_credits: f64,
//         fee_record: Option<RRecordPlaintext>,
//         url: Option<String>,
//         imports: Option<RHashMapStrings>,
//         proving_key: Option<RProvingKey>,
//         verifying_key: Option<RVerifyingKey>,
//         fee_proving_key: Option<RProvingKey>,
//         fee_verifying_key: Option<RVerifyingKey>,
//     ) -> Option<RTransaction> {
//         let r = || {
//             // log(&format!("Executing function: {function} on-chain"));
//             let fee_microcredits = match &fee_record {
//                 Some(fee_record) => Self::validate_amount(fee_credits, fee_record, true)?,
//                 None => (fee_credits * 1_000_000.0) as u64,
//             };
//             let mut process_native = ProcessNative::load_web().map_err(|err| err.to_string())?;
//             let process = &mut process_native;
//             const DEFAULT_URL: &str = "https://api.explorer.aleo.org/v1";
//             let node_url = url.as_deref().unwrap_or(DEFAULT_URL);

//             // log("Check program imports are valid and add them to the process");
//             let program_native = ProgramNative::from_str(program).map_err(|e| e.to_string())?;
//             RProgramManager::resolve_imports(process, &program_native, imports)?;
//             let rng = &mut StdRng::from_entropy();

//             // log("Executing program");
//             let (_, mut trace) = execute_program!(
//                 process,
//                 process_inputs!(inputs),
//                 program,
//                 function,
//                 private_key,
//                 proving_key,
//                 verifying_key,
//                 rng
//             );

//             // log("Preparing inclusion proofs for execution");
//             let query = QueryNative::from(node_url);
//             trace.prepare(query).map_err(|err| err.to_string())?;

//             // log("Proving execution");
//             let program = ProgramNative::from_str(program).map_err(|err| err.to_string())?;
//             let locator = program.id().to_string().add("/").add(function);
//             let execution = trace
//                 .prove_execution::<CurrentAleo, _>(&locator, &mut StdRng::from_entropy())
//                 .map_err(|e| e.to_string())?;
//             let execution_id = execution.to_execution_id().map_err(|e| e.to_string())?;

//             // log("Executing fee");
//             let fee = execute_fee!(
//                 process,
//                 private_key,
//                 fee_record,
//                 fee_microcredits,
//                 node_url,
//                 fee_proving_key,
//                 fee_verifying_key,
//                 execution_id,
//                 rng
//             );

//             // Verify the execution
//             process
//                 .verify_execution(&execution)
//                 .map_err(|err| err.to_string())?;

//             // log("Creating execution transaction");
//             let transaction = TransactionNative::from_execution(execution, Some(fee))
//                 .map_err(|err| err.to_string())?;
//             Ok(RTransaction::from(transaction))
//         };

//         match r() {
//             Ok(transaction) => Some(transaction),
//             Err(e) => None,
//         }
//     }

//     /// Check if a process contains a keypair for a specific function
//     pub(crate) fn contains_key(
//         process: &ProcessNative,
//         program_id: &ProgramIDNative,
//         function_id: &IdentifierNative,
//     ) -> bool {
//         process.get_stack(program_id).map_or_else(
//             |_| false,
//             |stack| {
//                 stack.contains_proving_key(function_id) && stack.contains_verifying_key(function_id)
//             },
//         )
//     }

//     /// Resolve imports for a program in depth first search order
//     pub(crate) fn resolve_imports(
//         process: &mut ProcessNative,
//         program: &ProgramNative,
//         imports: Option<RHashMapStrings>,
//     ) -> Result<(), String> {
//         if let Some(importsA) = imports {
//             let imports = importsA.0;
//             program.imports().keys().try_for_each(|program_id| {
//                 // Get the program string
//                 let program_id = program_id.to_string();
//                 if let Some(import_string) = imports.get(&program_id).cloned() {
//                     if &program_id != "credits.aleo" {
//                         let import = ProgramNative::from_str(&import_string)
//                             .map_err(|err| err.to_string())?;
//                         // If the program has imports, add them
//                         let new_imports = RHashMapStrings(imports.clone());
//                         Self::resolve_imports(process, &import, Some(new_imports))?;
//                         // If the process does not already contain the program, add it
//                         if !process.contains_program(import.id()) {
//                             process
//                                 .add_program(&import)
//                                 .map_err(|err| err.to_string())?;
//                         }
//                     }
//                 }
//                 Ok::<(), String>(())
//             })
//         } else {
//             Ok(())
//         }
//     }

//     /// Validate that an amount being paid from a record is greater than zero and that the record
//     /// has enough credits to pay the amount
//     pub(crate) fn validate_amount(
//         credits: f64,
//         amount: &RRecordPlaintext,
//         fee: bool,
//     ) -> Result<u64, String> {
//         let name = if fee { "Fee" } else { "Amount" };

//         if credits <= 0.0 {
//             return Err(format!(
//                 "{name} must be greater than zero to deploy or execute a program"
//             ));
//         }
//         let microcredits = (credits * 1_000_000.0f64) as u64;
//         if amount.r_microcredits() < microcredits {
//             return Err(format!(
//                 "{name} record does not have enough credits to pay the specified fee"
//             ));
//         }

//         Ok(microcredits)
//     }
// }

// impl RHashMapStrings {
//     fn r_new(vector: Vec<RKVPair>) -> RHashMapStrings {
//         let mut hash_map: HashMap<String, String> = HashMap::new();
//         for pair in vector.iter() {
//             hash_map.insert(pair.key.to_string(), pair.value.to_string());
//         }

//         return RHashMapStrings(hash_map);
//     }
// }

// impl RKVPair {
//     pub fn r_new(key: String, value: String) -> RKVPair {
//         return RKVPair {
//             key: key,
//             value: value,
//         };
//     }
// }
