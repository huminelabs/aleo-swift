use crate::programs::{RProvingKey, RVerifyingKey};

use crate::types::native::{ProvingKeyNative, VerifyingKeyNative};

#[swift_bridge::bridge]
pub mod ffi_key_pair {
    extern "Rust" {
        type RKeyPair;

        #[swift_bridge(already_declared)]
        type RProvingKey;
        #[swift_bridge(already_declared)]
        type RVerifyingKey;

        #[swift_bridge(init, associated_to = RKeyPair)]
        pub fn r_new(proving_key: RProvingKey, verifying_key: RVerifyingKey) -> RKeyPair;

        #[swift_bridge(associated_to = RKeyPair)]
        pub fn r_proving_key(self: &mut RKeyPair) -> Option<RProvingKey>;

        #[swift_bridge(associated_to = RKeyPair)]
        pub fn r_verifying_key(self: &mut RKeyPair) -> Option<RVerifyingKey>;
    }
}

#[derive(Clone, Debug)]
pub struct RKeyPair {
    proving_key: Option<RProvingKey>,
    verifying_key: Option<RVerifyingKey>,
}

impl RKeyPair {
    /// Create new key pair from proving and verifying keys
    ///
    /// @param {ProvingKey} proving_key Proving key corresponding to a function in an Aleo program
    /// @param {VerifyingKey} verifying_key Verifying key corresponding to a function in an Aleo program
    /// @returns {KeyPair} Key pair object containing both the function proving and verifying keys
    pub fn r_new(proving_key: RProvingKey, verifying_key: RVerifyingKey) -> RKeyPair {
        RKeyPair {
            proving_key: Some(proving_key),
            verifying_key: Some(verifying_key),
        }
    }

    /// Get the proving key. This method will remove the proving key from the key pair
    ///
    /// @returns {ProvingKey | Error}
    pub fn r_proving_key(&mut self) -> Option<RProvingKey> {
        self.proving_key.take()
    }

    /// Get the verifying key. This method will remove the verifying key from the key pair
    ///
    /// @returns {VerifyingKey | Error}
    pub fn r_verifying_key(&mut self) -> Option<RVerifyingKey> {
        self.verifying_key.take()
    }
}

impl From<(ProvingKeyNative, VerifyingKeyNative)> for RKeyPair {
    fn from((proving_key, verifying_key): (ProvingKeyNative, VerifyingKeyNative)) -> Self {
        Self::r_new(proving_key.into(), verifying_key.into())
    }
}
