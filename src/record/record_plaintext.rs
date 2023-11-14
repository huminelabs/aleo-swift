use crate::{account::RPrivateKey, types::RField, Credits};

use crate::types::native::{IdentifierNative, ProgramIDNative, RecordPlaintextNative};

use std::{ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_record_plaintext {
    extern "Rust" {
        type RRecordPlaintext;

        #[swift_bridge(already_declared)]
        type RPrivateKey;

        #[swift_bridge(already_declared)]
        type RField;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_from_string(string: &str) -> Option<RRecordPlaintext>;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_to_string(self: &RRecordPlaintext) -> String;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_microcredits(self: &RRecordPlaintext) -> u64;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_nonce(self: &RRecordPlaintext) -> String;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_serial_number_string(
            self: &RRecordPlaintext,
            private_key: &RPrivateKey,
            program_id: &str,
            record_name: &str,
        ) -> Option<String>;

        #[swift_bridge(associated_to = RRecordPlaintext)]
        pub fn r_commitment(
            self: &RRecordPlaintext,
            program_id: &str,
            record_name: &str,
        ) -> Option<RField>;
    }
}

/// Aleo record plaintext
#[derive(Clone)]
pub struct RRecordPlaintext(RecordPlaintextNative);

pub enum RecordPlaintextError {
    PlaintextStringInvalid,
    SerialNumberDerivationFailed,
    InvalidProgramName(String),
    InvalidIdentifier(String),
    Passthrough(String),
}

impl RRecordPlaintext {
    /// Return a record plaintext from a string.
    pub fn r_from_string(string: &str) -> Option<RRecordPlaintext> {
        Self::from_str(string)
            .map_err(|_| RecordPlaintextError::PlaintextStringInvalid)
            .ok()
    }

    /// Returns the record plaintext string
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Returns the amount of microcredits in the record
    pub fn r_microcredits(&self) -> u64 {
        self.0.microcredits().unwrap_or(0)
    }

    /// Returns the nonce of the record. This can be used to uniquely identify a record.
    ///
    /// @returns {string} Nonce of the record
    pub fn r_nonce(&self) -> String {
        self.0.nonce().to_string()
    }

    /// Attempt to get the serial number of a record to determine whether or not is has been spent
    pub fn r_serial_number_string(
        &self,
        private_key: &RPrivateKey,
        program_id: &str,
        record_name: &str,
    ) -> Option<String> {
        let commitment = self.r_commitment(program_id, record_name)?;

        let serial_number =
            RecordPlaintextNative::serial_number(private_key.into(), commitment.into())
                .map_err(|_| RecordPlaintextError::SerialNumberDerivationFailed);

        if let Some(serial_number) = serial_number.ok() {
            Some(serial_number.to_string())
        } else {
            None
        }
    }

    pub fn r_commitment(&self, program_id: &str, record_name: &str) -> Option<RField> {
        if let (Some(program_id), Some(record_name)) = (
            &ProgramIDNative::from_str(program_id).ok(),
            &IdentifierNative::from_str(record_name).ok(),
        ) {
            if let Some(commitment) = self.to_commitment(program_id, record_name).ok() {
                Some(RField::from(commitment))
            } else {
                None
            }
        } else {
            None
        }
    }
}

impl From<RecordPlaintextNative> for RRecordPlaintext {
    fn from(record: RecordPlaintextNative) -> Self {
        Self(record)
    }
}

impl FromStr for RRecordPlaintext {
    type Err = anyhow::Error;

    fn from_str(plaintext: &str) -> Result<Self, Self::Err> {
        Ok(Self(RecordPlaintextNative::from_str(plaintext)?))
    }
}

impl Deref for RRecordPlaintext {
    type Target = RecordPlaintextNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
