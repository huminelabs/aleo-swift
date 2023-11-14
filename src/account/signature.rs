use crate::{
    account::{RAddress, RPrivateKey},
    types::native::SignatureNative,
};

use core::{fmt, ops::Deref, str::FromStr};
use rand::{rngs::StdRng, SeedableRng};

#[swift_bridge::bridge]
pub mod ffi_signature {
    extern "Rust" {
        type RSignature;

        #[swift_bridge(already_declared)]
        type RAddress;
        #[swift_bridge(already_declared)]
        type RPrivateKey;

        #[swift_bridge(init, associated_to = RSignature)]
        pub fn r_sign(
            #[swift_bridge(label = "r_sign_init")] private_key: &RPrivateKey,
            message: &[u8],
        ) -> RSignature;

        #[swift_bridge(associated_to = RSignature)]
        pub fn r_verify(self: &RSignature, address: &RAddress, message: &[u8]) -> bool;

        #[swift_bridge(init, associated_to = RSignature)]
        pub fn r_from_string(
            #[swift_bridge(label = "r_from_string_init")] signature: &str,
        ) -> RSignature;

        #[swift_bridge(associated_to = RSignature)]
        pub fn r_to_string(self: &RSignature) -> String;
    }
}

pub struct RSignature(SignatureNative);

impl RSignature {
    pub fn r_sign(private_key: &RPrivateKey, message: &[u8]) -> Self {
        Self(
            SignatureNative::sign_bytes(private_key, message, &mut StdRng::from_entropy()).unwrap(),
        )
    }

    pub fn r_verify(&self, address: &RAddress, message: &[u8]) -> bool {
        self.0.verify_bytes(address, message)
    }

    pub fn r_from_string(signature: &str) -> Self {
        Self::from_str(signature).unwrap()
    }

    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }
}

impl FromStr for RSignature {
    type Err = anyhow::Error;

    fn from_str(signature: &str) -> Result<Self, Self::Err> {
        Ok(Self(SignatureNative::from_str(signature).unwrap()))
    }
}

impl fmt::Display for RSignature {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Deref for RSignature {
    type Target = SignatureNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
