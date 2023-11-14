use crate::types::native::{FromBytes, ToBytes, VerifyingKeyNative};

use std::{ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_verifying_key {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RVerifyingKey;

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_from_bytes(bytes: &[u8]) -> Option<RVerifyingKey>;

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_to_bytes(self: &RVerifyingKey) -> Option<Vec<u8>>;

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_from_string(string: &str) -> Option<RVerifyingKey>;

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_to_string(self: &RVerifyingKey) -> String;

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_copy(self: &RVerifyingKey) -> RVerifyingKey;
    }
}

/// Verifying key for a function within an Aleo program
#[derive(Clone, Debug)]
pub struct RVerifyingKey(VerifyingKeyNative);

impl RVerifyingKey {
    /// Construct a new verifying key from a byte array
    ///
    /// @param {Uint8Array} bytes Byte representation of a verifying key
    /// @returns {Option<VerifyingKey>}
    pub fn r_from_bytes(bytes: &[u8]) -> Option<RVerifyingKey> {
        if let Some(vk) = VerifyingKeyNative::from_bytes_le(bytes).ok() {
            Some(Self(vk))
        } else {
            None
        }
    }

    /// Create a byte array from a verifying key
    ///
    /// @returns {Option<Uint8Array>} Byte representation of a verifying key
    pub fn r_to_bytes(&self) -> Option<Vec<u8>> {
        self.0.to_bytes_le().ok()
    }

    /// Create a verifying key from string
    ///
    /// @param {String} string String representation of a verifying key
    /// @returns {Option<VerifyingKey>}
    pub fn r_from_string(string: &str) -> Option<RVerifyingKey> {
        if let Some(vk) = VerifyingKeyNative::from_str(string).ok() {
            Some(Self(vk))
        } else {
            None
        }
    }

    /// Get a string representation of the verifying key
    ///
    /// @returns {String} String representation of the verifying key
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Create a copy of the verifying key
    ///
    /// @returns {VerifyingKey} A copy of the verifying key
    pub fn r_copy(&self) -> RVerifyingKey {
        self.0.clone().into()
    }
}

impl Deref for RVerifyingKey {
    type Target = VerifyingKeyNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<RVerifyingKey> for VerifyingKeyNative {
    fn from(verifying_key: RVerifyingKey) -> VerifyingKeyNative {
        verifying_key.0
    }
}

impl From<&RVerifyingKey> for VerifyingKeyNative {
    fn from(verifying_key: &RVerifyingKey) -> VerifyingKeyNative {
        verifying_key.0.clone()
    }
}

impl From<VerifyingKeyNative> for RVerifyingKey {
    fn from(verifying_key: VerifyingKeyNative) -> RVerifyingKey {
        RVerifyingKey(verifying_key)
    }
}

impl PartialEq for RVerifyingKey {
    fn eq(&self, other: &Self) -> bool {
        *self.0 == *other.0
    }
}
