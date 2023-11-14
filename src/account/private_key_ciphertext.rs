use crate::{
    account::{Encryptor, RPrivateKey},
    types::native::CiphertextNative,
};

use std::{convert::TryFrom, ops::Deref, str::FromStr};

#[swift_bridge::bridge]
pub mod ffi_private_key_ciphertext {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RPrivateKeyCiphertext;

        #[swift_bridge(already_declared)]
        type RPrivateKey;

        #[swift_bridge(associated_to = RPrivateKeyCiphertext)]
        pub fn r_encrypt_private_key(
            private_key: &RPrivateKey,
            secret: &str,
        ) -> Option<RPrivateKeyCiphertext>;

        #[swift_bridge(associated_to = RPrivateKeyCiphertext)]
        pub fn r_decrypt_to_private_key(
            self: &RPrivateKeyCiphertext,
            secret: &str,
        ) -> Option<RPrivateKey>;

        #[swift_bridge(associated_to = RPrivateKeyCiphertext)]
        pub fn r_to_string(self: &RPrivateKeyCiphertext) -> String;

        #[swift_bridge(associated_to = RPrivateKeyCiphertext)]
        pub fn r_from_string(string: String) -> Option<RPrivateKeyCiphertext>;
    }
}

#[derive(Clone, Eq, PartialEq)]
pub struct RPrivateKeyCiphertext(CiphertextNative);

pub enum PrivateKeyCiphertextError {
    EncryptionFailed,
    DecryptionFailed,
    InvalidCiphertext,
}

impl RPrivateKeyCiphertext {
    pub fn r_encrypt_private_key(
        private_key: &RPrivateKey,
        secret: &str,
    ) -> Option<RPrivateKeyCiphertext> {
        let ciphertext = Encryptor::encrypt_private_key_with_secret(private_key, secret)
            .map_err(|_| PrivateKeyCiphertextError::EncryptionFailed)
            .ok()?;
        return Some(Self::from(ciphertext));
    }

    pub fn r_decrypt_to_private_key(&self, secret: &str) -> Option<RPrivateKey> {
        let private_key = Encryptor::decrypt_private_key_with_secret(&self.0, secret)
            .map_err(|_| PrivateKeyCiphertextError::DecryptionFailed)
            .ok()?;
        return Some(RPrivateKey::from(private_key));
    }

    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    pub fn r_from_string(string: String) -> Option<RPrivateKeyCiphertext> {
        let ciphertext = Self::try_from(string)
            .map_err(|_| PrivateKeyCiphertextError::InvalidCiphertext)
            .ok();
        return ciphertext;
    }
}

impl From<CiphertextNative> for RPrivateKeyCiphertext {
    fn from(ciphertext: CiphertextNative) -> Self {
        Self(ciphertext)
    }
}

impl TryFrom<String> for RPrivateKeyCiphertext {
    type Error = PrivateKeyCiphertextError;

    fn try_from(ciphertext: String) -> Result<Self, Self::Error> {
        Ok(Self(CiphertextNative::from_str(&ciphertext).map_err(
            |_| PrivateKeyCiphertextError::InvalidCiphertext,
        )?))
    }
}

impl Deref for RPrivateKeyCiphertext {
    type Target = CiphertextNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
