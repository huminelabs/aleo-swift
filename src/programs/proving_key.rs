use crate::types::native::{FromBytes, ProvingKeyNative, ToBytes};

use sha2::Digest;

use std::{ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_proving_key {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RProvingKey;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_from_bytes(bytes: &[u8]) -> Option<RProvingKey>;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_from_string(string: &str) -> Option<RProvingKey>;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_to_bytes(self: &RProvingKey) -> Option<Vec<u8>>;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_to_string(self: &RProvingKey) -> String;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_copy(self: &RProvingKey) -> RProvingKey;

        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_bond_public_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_claim_unbond_public_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_fee_private_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_fee_public_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_inclusion_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_join_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_set_validator_state_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_split_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_transfer_private_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_transfer_private_to_public_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_transfer_public_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_transfer_public_to_private_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_unbond_delegator_as_validator_prover(self: &RProvingKey) -> bool;
        #[swift_bridge(associated_to = RProvingKey)]
        pub fn r_is_unbond_public_prover(self: &RProvingKey) -> bool;
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

    /// Create a proving key from string
    ///
    /// @param {string | Error} String representation of the proving key
    pub fn r_from_string(string: &str) -> Option<RProvingKey> {
        if let Some(pk) = ProvingKeyNative::from_str(string).ok() {
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

    /// Get a string representation of the proving key
    ///
    /// @returns {string} String representation of the proving key
    pub fn r_to_string(self: &RProvingKey) -> String {
        return self.0.to_string();
    }

    /// Create a copy of the proving key
    ///
    /// @returns {ProvingKey} A copy of the proving key
    pub fn r_copy(&self) -> RProvingKey {
        self.0.clone().into()
    }

    /// Return the checksum of the proving key
    ///
    /// @returns {string} Checksum of the proving key
    pub fn checksum(&self) -> String {
        hex::encode(sha2::Sha256::digest(self.r_to_bytes().unwrap()))
    }

    fn prover_checksum(function_metadata: &'static str) -> String {
        let metadata: serde_json::Value =
            serde_json::from_str(function_metadata).expect("Metadata was not well-formatted");
        metadata["prover_checksum"]
            .as_str()
            .expect("Failed to parse checksum")
            .to_string()
    }

    /// Verify if the proving key is for the bond_public function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("bond_public_proving_key.bin");
    /// provingKey.isBondPublicProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the bond_public function, false if otherwise
    pub fn r_is_bond_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::BondPublicProver::METADATA,
            )
    }

    /// Verify if the proving key is for the claim_unbond function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("claim_unbond_proving_key.bin");
    /// provingKey.isClaimUnbondProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the claim_unbond function, false if otherwise
    pub fn r_is_claim_unbond_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::ClaimUnbondPublicProver::METADATA,
            )
    }

    /// Verify if the proving key is for the fee_private function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("fee_private_proving_key.bin");
    /// provingKey.isFeePrivateProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the fee_private function, false if otherwise
    pub fn r_is_fee_private_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::FeePrivateProver::METADATA,
            )
    }

    /// Verify if the proving key is for the fee_public function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("fee_public_proving_key.bin");
    /// provingKey.isFeePublicProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the fee_public function, false if otherwise
    pub fn r_is_fee_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(snarkvm_parameters::testnet3::FeePublicProver::METADATA)
    }

    /// Verify if the proving key is for the inclusion function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("inclusion_proving_key.bin");
    /// provingKey.isInclusionProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the inclusion function, false if otherwise
    pub fn r_is_inclusion_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(snarkvm_parameters::testnet3::InclusionProver::METADATA)
    }

    /// Verify if the proving key is for the join function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("join_proving_key.bin");
    /// provingKey.isJoinProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the join function, false if otherwise
    pub fn r_is_join_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(snarkvm_parameters::testnet3::JoinProver::METADATA)
    }

    /// Verify if the proving key is for the set_validator_state function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("set_validator_set_proving_key.bin");
    /// provingKey.isSetValidatorStateProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the set_validator_state function, false if otherwise
    pub fn r_is_set_validator_state_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::SetValidatorStateProver::METADATA,
            )
    }

    /// Verify if the proving key is for the split function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("split_proving_key.bin");
    /// provingKey.isSplitProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the split function, false if otherwise
    pub fn r_is_split_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(snarkvm_parameters::testnet3::SplitProver::METADATA)
    }

    /// Verify if the proving key is for the transfer_private function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("transfer_private_proving_key.bin");
    /// provingKey.isTransferPrivateProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the transfer_private function, false if otherwise
    pub fn r_is_transfer_private_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::TransferPrivateProver::METADATA,
            )
    }

    /// Verify if the proving key is for the transfer_private_to_public function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("transfer_private_to_public_proving_key.bin");
    /// provingKey.isTransferPrivateToPublicProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the transfer_private_to_public function, false if otherwise
    pub fn r_is_transfer_private_to_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::TransferPrivateToPublicProver::METADATA,
            )
    }

    /// Verify if the proving key is for the transfer_public function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("transfer_public_proving_key.bin");
    /// provingKey.isTransferPublicProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the transfer_public function, false if otherwise
    pub fn r_is_transfer_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::TransferPublicProver::METADATA,
            )
    }

    /// Verify if the proving key is for the transfer_public_to_private function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("transfer_public_to_private_proving_key.bin");
    /// provingKey.isTransferPublicToPrivateProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the transfer_public_to_private function, false if otherwise
    pub fn r_is_transfer_public_to_private_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::TransferPublicToPrivateProver::METADATA,
            )
    }

    /// Verify if the proving key is for the unbond_delegator_as_validator function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("unbond_delegator_as_validator_proving_key.bin");
    /// provingKey.isUnbondDelegatorAsValidatorProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the unbond_delegator_as_validator function, false if otherwise
    pub fn r_is_unbond_delegator_as_validator_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::UnbondDelegatorAsValidatorProver::METADATA,
            )
    }

    /// Verify if the proving key is for the unbond_delegator_as_delegator function
    ///
    /// @example
    /// const provingKey = ProvingKey.fromBytes("unbond_delegator_as_delegator_proving_key.bin");
    /// provingKey.isUnbondDelegatorAsDelegatorProver() ? console.log("Key verified") : throw new Error("Invalid key");
    ///
    /// @returns {boolean} returns true if the proving key is for the unbond_delegator_as_delegator function, false if otherwise
    pub fn r_is_unbond_public_prover(&self) -> bool {
        self.checksum()
            == RProvingKey::prover_checksum(
                snarkvm_parameters::testnet3::UnbondPublicProver::METADATA,
            )
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
