use super::{RAddress, RPrivateKey};
use crate::{record::RRecordCiphertext, types::native::ViewKeyNative};

use core::{convert::TryFrom, fmt, ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_view_key {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RViewKey;

        #[swift_bridge(already_declared)]
        type RAddress;
        #[swift_bridge(already_declared)]
        type RPrivateKey;

        #[swift_bridge(init, associated_to = RViewKey)]
        pub fn r_from_private_key(
            #[swift_bridge(label = "r_private_key")] private_key: &RPrivateKey,
        ) -> RViewKey;

        #[swift_bridge(init, associated_to = RViewKey)]
        pub fn r_from_string(
            #[swift_bridge(label = "r_view_key_string")] view_key: &str,
        ) -> RViewKey;

        #[swift_bridge(associated_to = RViewKey)]
        pub fn r_to_string(self: &RViewKey) -> String;
        #[swift_bridge(associated_to = RViewKey)]
        pub fn r_to_address(self: &RViewKey) -> RAddress;
        #[swift_bridge(associated_to = RViewKey)]
        pub fn r_decrypt(self: &RViewKey, ciphertext: &str) -> Option<String>;
    }
}

#[derive(Clone, PartialEq, Eq)]
pub struct RViewKey(ViewKeyNative);

pub enum ViewKeyError {
    PassthroughError(String),
}

impl RViewKey {
    pub fn r_from_private_key(private_key: &RPrivateKey) -> Self {
        Self(ViewKeyNative::try_from(**private_key).unwrap())
    }

    pub fn r_from_string(view_key: &str) -> Self {
        Self::from_str(view_key).unwrap()
    }

    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    pub fn r_to_address(&self) -> RAddress {
        RAddress::r_from_view_key(self)
    }

    pub fn r_decrypt(&self, ciphertext: &str) -> Option<String> {
        let ciphertext = RRecordCiphertext::from_str(ciphertext).ok();
        if let Some(decrypted) = ciphertext?.r_decrypt(self) {
            Some(decrypted.r_to_string())
        } else {
            None
        }
    }
}

impl FromStr for RViewKey {
    type Err = anyhow::Error;

    fn from_str(view_key: &str) -> Result<Self, Self::Err> {
        Ok(Self(ViewKeyNative::from_str(view_key)?))
    }
}

impl fmt::Display for RViewKey {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Deref for RViewKey {
    type Target = ViewKeyNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
