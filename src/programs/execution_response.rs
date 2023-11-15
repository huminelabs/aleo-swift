use crate::types::native::{
    ExecutionNative, IdentifierNative, ProcessNative, ProgramIDNative, ProgramNative,
    ProvingKeyNative, ResponseNative, VerifyingKeyNative,
};

use crate::{Execution, KeyPair, Program, ProvingKey, VerifyingKey};
use std::{ops::Deref, str::FromStr};

/// Webassembly Representation of an Aleo function execution response
///
/// This object is returned by the execution of an Aleo function off-chain. It provides methods for
/// retrieving the outputs of the function execution.
pub struct RExecutionResponse {
    execution: Option<ExecutionNative>,
    function_id: IdentifierNative,
    response: ResponseNative,
    program: ProgramNative,
    proving_key: Option<ProvingKeyNative>,
    verifying_key: VerifyingKeyNative,
}

impl RExecutionResponse {
    pub(crate) fn new(
        execution: Option<ExecutionNative>,
        function_id: &str,
        response: ResponseNative,
        process: &ProcessNative,
        program: &str,
    ) -> Result<Self, String> {
        let program = ProgramNative::from_str(program).map_err(|e| e.to_string())?;
        let verifying_key = process
            .get_verifying_key(program.id(), function_id)
            .map_err(|_| {
                format!(
                    "Could not find verifying key for {:?}/{:?}",
                    program.id(),
                    function_id
                )
            })?;

        Ok(Self {
            execution,
            response,
            function_id: IdentifierNative::from_str(function_id).map_err(|e| e.to_string())?,
            program,
            proving_key: None,
            verifying_key,
        })
    }

    pub(crate) fn add_proving_key(
        &mut self,
        process: &ProcessNative,
        function_id: &str,
        program_id: &ProgramIDNative,
    ) -> Result<(), String> {
        let proving_key = process
            .get_proving_key(program_id, function_id)
            .map_err(|_| {
                format!(
                    "Could not find proving key for {:?}/{:?}",
                    program_id, function_id
                )
            })?;
        self.proving_key = Some(proving_key);
        Ok(())
    }

    /// Get the outputs of the executed function
    ///
    /// @returns {Array} Array of strings representing the outputs of the function
    pub fn get_outputs(&self) -> js_sys::Array {
        let array = js_sys::Array::new_with_length(0u32);
        self.response
            .outputs()
            .iter()
            .enumerate()
            .for_each(|(i, output)| {
                array.set(i as u32, JsValue::from_str(&output.to_string()));
            });
        array
    }

    /// Returns the execution object if present, null if otherwise.
    ///
    /// @returns {Execution | undefined} The execution object if present, null if otherwise
    pub fn get_execution(&self) -> Option<Execution> {
        self.execution.clone().map(Execution::from)
    }

    /// Returns the program keys if present
    pub fn get_keys(&mut self) -> Result<KeyPair, String> {
        if let Some(proving_key) = self.proving_key.take() {
            Ok(KeyPair::new(
                ProvingKey::from(proving_key),
                VerifyingKey::from(self.verifying_key.clone()),
            ))
        } else {
            Err("No proving key found".to_string())
        }
    }

    /// Returns the proving_key if the proving key was cached in the Execution response.
    /// Note the proving key is removed from the response object after the first call to this
    /// function. Subsequent calls will return null.
    ///
    /// @returns {ProvingKey | undefined} The proving key
    pub fn get_proving_key(&mut self) -> Option<ProvingKey> {
        self.proving_key.take().map(ProvingKey::from)
    }

    /// Returns the verifying_key associated with the program
    ///
    /// @returns {VerifyingKey} The verifying key
    pub fn get_verifying_key(&self) -> VerifyingKey {
        VerifyingKey::from(self.verifying_key.clone())
    }

    /// Returns the function identifier
    pub fn get_function_id(&self) -> String {
        format!("{:?}", self.function_id)
    }

    /// Returns the program
    pub fn get_program(&self) -> Program {
        Program::from(self.program.clone())
    }
}
