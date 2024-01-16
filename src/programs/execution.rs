pub use super::*;
use std::{ops::Deref, str::FromStr};

use crate::types::native::{
    CurrentNetwork, ExecutionNative, IdentifierNative, ProcessNative, ProgramID, VerifyingKeyNative,
};

#[swift_bridge::bridge]
pub mod ffi_execution {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RExecution;

        #[swift_bridge(associated_to = RExecuction)]
        pub fn r_to_string(self: &RExecuction) -> String;

        #[swift_bridge(associated_to = RExecuction)]
        pub fn r_from_string(execution: &str) -> Option<RExecution>;

        #[swift_bridge(associated_to = RExecuction)]
        pub fn r_verify_function_execution(
            execution: &RExecution,
            verifying_key: &RVerifyingKey,
            program: &RProgram,
            function_id: &str,
        ) -> Option<bool>;
    }
}

/// Execution of an Aleo program.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RExecution(ExecutionNative);

impl RExecution {
    /// Returns the string representation of the execution.
    #[allow(clippy::inherent_to_string)]
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Creates an execution object from a string representation of an execution.
    pub fn r_from_string(execution: &str) -> Option<RExecution> {
        if let Some(exec_native) = ExecutionNative::from_str(execution).ok() {
            Some(Self(exec_native))
        } else {
            None
        }
    }
}

impl From<ExecutionNative> for RExecution {
    fn from(native: ExecutionNative) -> Self {
        Self(native)
    }
}

impl From<RExecution> for ExecutionNative {
    fn from(execution: RExecution) -> Self {
        execution.0
    }
}

impl Deref for RExecution {
    type Target = ExecutionNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

/// Verify an execution with a single function and a single transition. Executions with multiple
/// transitions or functions will fail to verify. Also, this does not verify that the state root of
/// the execution is included in the Aleo Network ledger.
///
/// @param {Execution} execution The function execution to verify
/// @param {VerifyingKey} verifying_key The verifying key for the function
/// @param {Program} program The program that the function execution belongs to
/// @param {String} function_id The name of the function that was executed
/// @returns {boolean} True if the execution is valid, false otherwise
pub fn r_verify_function_execution(
    execution: &RExecution,
    verifying_key: &RVerifyingKey,
    program: &RProgram,
    function_id: &str,
) -> Option<bool> {
    let function = IdentifierNative::from_str(function_id).map_err(|e| e.to_string())?;
    let program_id = ProgramID::<CurrentNetwork>::from_str(&program.id()).unwrap();
    let mut process = ProcessNative::load_web().map_err(|e| e.to_string())?;
    if &program.r_id() != "credits.aleo" {
        process.add_program(program).map_err(|e| e.to_string())?;
    }
    process
        .insert_verifying_key(
            &program_id,
            &function,
            VerifyingKeyNative::from(verifying_key),
        )
        .map_err(|e| e.to_string())
        .ok();
    process
        .verify_execution(execution)
        .map_or(Ok(false), |_| Ok(true))
        .ok()
}
