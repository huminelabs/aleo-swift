use crate::types::native::{FromBytes, ProvingKeyNative, ToBytes};

use std::ops::Deref;

#[swift_bridge::bridge]
pub mod ffi_proving_key {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RProvingKey;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_from_bytes(bytes: &[u8]) -> Option<RProvingKey>;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_to_bytes(self: &RProvingKey) -> Option<Vec<u8>>;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_copy(self: &RProvingKey) -> RProvingKey;
    }
}

/// Proving key for a function within an Aleo program
#[derive(Clone, Debug)]
pub struct RProvingKey(ProvingKeyNative);

impl RProvingKey {
    /// Construct a new proving key from a byte array
    ///
    /// @param {Uint8Array} bytes Byte array representation of a proving key
    /// @returns {Option<ProvingKey>}
    pub fn r_from_bytes(bytes: &[u8]) -> Option<RProvingKey> {
        if let Some(pk) = ProvingKeyNative::from_bytes_le(bytes).ok() {
            Some(Self(pk))
        } else {
            None
        }
    }

    /// Return the byte representation of a proving key
    ///
    /// @returns {Option<Uint8Array>} Byte array representation of a proving key
    pub fn r_to_bytes(&self) -> Option<Vec<u8>> {
        return self.0.to_bytes_le().ok();
    }

    /// Create a copy of the proving key
    ///
    /// @returns {ProvingKey} A copy of the proving key
    pub fn r_copy(&self) -> RProvingKey {
        self.0.clone().into()
    }
}

impl Deref for RProvingKey {
    type Target = ProvingKeyNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<RProvingKey> for ProvingKeyNative {
    fn from(proving_key: RProvingKey) -> ProvingKeyNative {
        proving_key.0
    }
}

impl From<ProvingKeyNative> for RProvingKey {
    fn from(proving_key: ProvingKeyNative) -> RProvingKey {
        RProvingKey(proving_key)
    }
}

impl PartialEq for RProvingKey {
    fn eq(&self, other: &Self) -> bool {
        *self.0 == *other.0
    }
}
