use super::RRecordPlaintext;
use crate::account::RViewKey;

use crate::types::native::RecordCiphertextNative;

use std::{ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_record_ciphertext {
    extern "Rust" {
        type RRecordCiphertext;

        #[swift_bridge(already_declared)]
        type RRecordPlaintext;
        #[swift_bridge(already_declared)]
        type RViewKey;

        #[swift_bridge(associated_to = RRecordCiphertext)]
        pub fn r_from(string: &str) -> Option<RRecordCiphertext>;

        #[swift_bridge(associated_to = RRecordCiphertext)]
        pub fn r_to_string(self: &RRecordCiphertext) -> String;

        #[swift_bridge(associated_to = RRecordCiphertext)]
        pub fn r_decrypt(self: &RRecordCiphertext, view_key: &RViewKey)
            -> Option<RRecordPlaintext>;

        #[swift_bridge(associated_to = RRecordCiphertext)]
        pub fn r_is_owner(self: &RRecordCiphertext, view_key: &RViewKey) -> bool;
    }
}

/// Encrypted Aleo record
#[derive(Clone)]
pub struct RRecordCiphertext(RecordCiphertextNative);

pub enum RecordCiphertextError {
    CiphertextStringInvalid,
    DecryptionFailed,
}

impl RRecordCiphertext {
    /// Return a record ciphertext from a string.
    pub fn r_from(string: &str) -> Option<RRecordCiphertext> {
        Self::from_str(string).ok()
    }

    /// Return the record ciphertext string.
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Decrypt the record ciphertext into plaintext using the view key.
    pub fn r_decrypt(&self, view_key: &RViewKey) -> Option<RRecordPlaintext> {
        if let Some(decrypted) = self.0.decrypt(view_key).ok() {
            Some(RRecordPlaintext::from(decrypted))
        } else {
            None
        }
    }

    /// Returns `true` if the view key can decrypt the record ciphertext.
    pub fn r_is_owner(&self, view_key: &RViewKey) -> bool {
        self.0.is_owner(view_key)
    }
}

impl FromStr for RRecordCiphertext {
    type Err = anyhow::Error;

    fn from_str(ciphertext: &str) -> Result<Self, Self::Err> {
        Ok(Self(RecordCiphertextNative::from_str(ciphertext)?))
    }
}

impl Deref for RRecordCiphertext {
    type Target = RecordCiphertextNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
