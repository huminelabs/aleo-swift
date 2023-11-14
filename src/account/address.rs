use crate::{
    account::{RPrivateKey, RSignature, RViewKey},
    types::native::AddressNative,
};

use core::{convert::TryFrom, fmt, ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_address {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RAddress;

        #[swift_bridge(already_declared)]
        type RPrivateKey;
        #[swift_bridge(already_declared)]
        type RViewKey;
        #[swift_bridge(already_declared)]
        type RSignature;

        #[swift_bridge(init, associated_to = RAddress)]
        pub fn r_from_private_key(
            #[swift_bridge(label = "r_private_key")] private_key: &RPrivateKey,
        ) -> RAddress;
        #[swift_bridge(init, associated_to = RAddress)]
        pub fn r_from_view_key(
            #[swift_bridge(label = "r_view_key")] view_key: &RViewKey,
        ) -> RAddress;
        #[swift_bridge(init, associated_to = RAddress)]
        pub fn r_from_string(#[swift_bridge(label = "r_string")] address: String) -> RAddress;

        #[swift_bridge(associated_to = RAddress)]
        pub fn r_to_string(self: &RAddress) -> String;
        #[swift_bridge(associated_to = RAddress)]
        pub fn r_verify(self: &RAddress, message: &[u8], signature: &RSignature) -> bool;
    }
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub struct RAddress(AddressNative);

impl RAddress {
    pub fn r_from_private_key(private_key: &RPrivateKey) -> Self {
        Self(AddressNative::try_from(**private_key).unwrap())
    }

    pub fn r_from_view_key(view_key: &RViewKey) -> Self {
        Self(AddressNative::try_from(**view_key).unwrap())
    }

    pub fn r_from_string(address: String) -> Self {
        Self::from_str(address.as_str()).unwrap()
    }

    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    pub fn r_verify(&self, message: &[u8], signature: &RSignature) -> bool {
        signature.r_verify(self, message)
    }
}

impl FromStr for RAddress {
    type Err = anyhow::Error;

    fn from_str(address: &str) -> Result<Self, Self::Err> {
        Ok(Self(AddressNative::from_str(address)?))
    }
}

impl fmt::Display for RAddress {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Deref for RAddress {
    type Target = AddressNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
