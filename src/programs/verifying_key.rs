use crate::types::native::{FromBytes, ToBytes, VerifyingKeyNative};

use sha2::Digest;

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

        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_bond_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_claim_unbond_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_fee_private_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_fee_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_inclusion_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_join_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_set_validator_state_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_split_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_transfer_private_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_transfer_private_to_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_transfer_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_transfer_public_to_private_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_unbond_delegator_as_validator_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_unbond_public_verifier() -> RVerifyingKey;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_bond_public_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_claim_unbond_public_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_fee_private_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_fee_public_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_inclusion_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_join_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_set_validator_state_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_split_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_transfer_private_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_transfer_private_to_public_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_transfer_public_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_transfer_public_to_private_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_unbond_delegator_as_validator_verifier(self: &RVerifyingKey) -> bool;
        #[swift_bridge(associated_to = RVerifyingKey)]
        pub fn r_is_unbond_public_verifier(self: &RVerifyingKey) -> bool;
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

    /// Get the checksum of the verifying key
    ///
    /// @returns {string} Checksum of the verifying key
    pub fn checksum(&self) -> String {
        hex::encode(sha2::Sha256::digest(self.r_to_bytes().unwrap()))
    }

    /// Returns the verifying key for the bond_public function
    ///
    /// @returns {VerifyingKey} Verifying key for the bond_public function
    pub fn r_bond_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::BondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the claim_delegator function
    ///
    /// @returns {VerifyingKey} Verifying key for the claim_unbond_public function
    pub fn r_claim_unbond_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::ClaimUnbondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the fee_private function
    ///
    /// @returns {VerifyingKey} Verifying key for the fee_private function
    pub fn r_fee_private_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::FeePrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the fee_public function
    ///
    /// @returns {VerifyingKey} Verifying key for the fee_public function
    pub fn r_fee_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::FeePublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the inclusion function
    ///
    /// @returns {VerifyingKey} Verifying key for the inclusion function
    pub fn r_inclusion_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::InclusionVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the join function
    ///
    /// @returns {VerifyingKey} Verifying key for the join function
    pub fn r_join_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::JoinVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the set_validator_state function
    ///
    /// @returns {VerifyingKey} Verifying key for the set_validator_state function
    pub fn r_set_validator_state_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::SetValidatorStateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the split function
    ///
    /// @returns {VerifyingKey} Verifying key for the split function
    pub fn r_split_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::SplitVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the transfer_private function
    ///
    /// @returns {VerifyingKey} Verifying key for the transfer_private function
    pub fn r_transfer_private_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the transfer_private_to_public function
    ///
    /// @returns {VerifyingKey} Verifying key for the transfer_private_to_public function
    pub fn r_transfer_private_to_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPrivateToPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the transfer_public function
    ///
    /// @returns {VerifyingKey} Verifying key for the transfer_public function
    pub fn r_transfer_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the transfer_public_to_private function
    ///
    /// @returns {VerifyingKey} Verifying key for the transfer_public_to_private function
    pub fn r_transfer_public_to_private_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPublicToPrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the unbond_delegator_as_delegator function
    ///
    /// @returns {VerifyingKey} Verifying key for the unbond_delegator_as_delegator function
    pub fn r_unbond_delegator_as_validator_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::UnbondDelegatorAsValidatorVerifier::load_bytes()
                .unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the unbond_delegator_as_delegator function
    ///
    /// @returns {VerifyingKey} Verifying key for the unbond_delegator_as_delegator function
    pub fn r_unbond_public_verifier() -> RVerifyingKey {
        RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::UnbondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Returns the verifying key for the bond_public function
    ///
    /// @returns {VerifyingKey} Verifying key for the bond_public function
    pub fn r_is_bond_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::BondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the claim_delegator function
    ///
    /// @returns {bool}
    pub fn r_is_claim_unbond_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::ClaimUnbondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the fee_private function
    ///
    /// @returns {bool}
    pub fn r_is_fee_private_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::FeePrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the fee_public function
    ///
    /// @returns {bool}
    pub fn r_is_fee_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::FeePublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the inclusion function
    ///
    /// @returns {bool}
    pub fn r_is_inclusion_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::InclusionVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the join function
    ///
    /// @returns {bool}
    pub fn r_is_join_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::JoinVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the set_validator_state function
    ///
    /// @returns {bool}
    pub fn r_is_set_validator_state_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::SetValidatorStateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the split function
    ///
    /// @returns {bool}
    pub fn r_is_split_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::SplitVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the transfer_private function
    ///
    /// @returns {bool}
    pub fn r_is_transfer_private_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the transfer_private_to_public function
    ///
    /// @returns {bool}
    pub fn r_is_transfer_private_to_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPrivateToPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the transfer_public function
    ///
    /// @returns {bool}
    pub fn r_is_transfer_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the transfer_public_to_private function
    ///
    /// @returns {bool}
    pub fn r_is_transfer_public_to_private_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::TransferPublicToPrivateVerifier::load_bytes().unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the unbond_delegator_as_delegator function
    ///
    /// @returns {bool}
    pub fn r_is_unbond_delegator_as_validator_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::UnbondDelegatorAsValidatorVerifier::load_bytes()
                .unwrap(),
        )
        .unwrap()
    }

    /// Verifies the verifying key is for the unbond_public function
    ///
    /// @returns {bool}
    pub fn r_is_unbond_public_verifier(&self) -> bool {
        self == &RVerifyingKey::r_from_bytes(
            &snarkvm_parameters::testnet3::UnbondPublicVerifier::load_bytes().unwrap(),
        )
        .unwrap()
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
