use crate::account::{Encryptor, RAddress, RPrivateKeyCiphertext, RSignature, RViewKey};
use crate::types::native::{
    CurrentNetwork, Environment, FromBytes, PrimeField, PrivateKeyNative, ToBytes,
};

use core::{convert::TryInto, fmt, ops::Deref, str::FromStr};
use rand::{rngs::StdRng, SeedableRng};

#[swift_bridge::bridge]
mod ffi_private_key {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RPrivateKey;

        #[swift_bridge(already_declared)]
        type RPrivateKeyCiphertext;
        #[swift_bridge(already_declared)]
        type RViewKey;
        #[swift_bridge(already_declared)]
        type RAddress;
        #[swift_bridge(already_declared)]
        type RSignature;

        #[swift_bridge(init, associated_to = RPrivateKey)]
        pub fn new() -> RPrivateKey;

        #[swift_bridge(init, associated_to = RPrivateKey)]
        pub fn r_from_seed_unchecked(#[swift_bridge(label = "r_seed")] seed: &[u8]) -> RPrivateKey;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_from_string(private_key: &str) -> Option<RPrivateKey>;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_to_string(self: &RPrivateKey) -> String;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_to_view_key(self: &RPrivateKey) -> RViewKey;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_to_address(self: &RPrivateKey) -> RAddress;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_sign(self: &RPrivateKey, message: &[u8]) -> RSignature;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_new_encrypted(secret: &str) -> Option<RPrivateKeyCiphertext>;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_to_ciphertext(self: &RPrivateKey, secret: &str) -> Option<RPrivateKeyCiphertext>;

        #[swift_bridge(associated_to = RPrivateKey)]
        pub fn r_from_private_key_ciphertext(
            ciphertext: &RPrivateKeyCiphertext,
            secret: &str,
        ) -> Option<RPrivateKey>;
    }
}

#[derive(Clone, Eq, PartialEq)]
pub struct RPrivateKey(PrivateKeyNative);

pub enum PrivateKeyError {
    InvalidPrivateKey,
    EncryptionFailed,
    DecryptionFailed,
}

impl RPrivateKey {
    /// Generate a new private key
    pub fn new() -> Self {
        Self(PrivateKeyNative::new(&mut StdRng::from_entropy()).unwrap())
    }

    /// Get a private key from a series of unchecked bytes
    pub fn r_from_seed_unchecked(seed: &[u8]) -> RPrivateKey {
        // Cast into a fixed-size byte array. Note: This is a **hard** requirement for security.
        let seed: [u8; 32] = seed.try_into().unwrap();
        // Recover the field element deterministically.
        let field = <CurrentNetwork as Environment>::Field::from_bytes_le_mod_order(&seed);
        // Cast and recover the private key from the seed.
        Self(
            PrivateKeyNative::try_from(FromBytes::read_le(&*field.to_bytes_le().unwrap()).unwrap())
                .unwrap(),
        )
    }

    /// Create a private key from a string representation
    ///
    /// This function will fail if the text is not a valid private key
    pub fn r_from_string(private_key: &str) -> Option<RPrivateKey> {
        let private_key =
            Self::from_str(private_key).map_err(|_| PrivateKeyError::InvalidPrivateKey);
        return private_key.ok();
    }

    /// Get a string representation of the private key
    ///
    /// This function should be used very carefully as it exposes the private key plaintext
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Get the view key corresponding to the private key
    pub fn r_to_view_key(&self) -> RViewKey {
        RViewKey::r_from_private_key(self)
    }

    /// Get the address corresponding to the private key
    pub fn r_to_address(&self) -> RAddress {
        RAddress::r_from_private_key(self)
    }

    /// Sign a message with the private key
    pub fn r_sign(&self, message: &[u8]) -> RSignature {
        RSignature::r_sign(self, message)
    }

    /// Get a private key ciphertext using a secret.
    ///
    /// The secret is sensitive and will be needed to decrypt the private key later, so it should be stored securely
    pub fn r_new_encrypted(secret: &str) -> Option<RPrivateKeyCiphertext> {
        let key = Self::new();
        if let Some(ciphertext) = Encryptor::encrypt_private_key_with_secret(&key, secret).ok() {
            Some(RPrivateKeyCiphertext::from(ciphertext))
        } else {
            None
        }
    }

    /// Encrypt the private key with a secret.
    ///
    /// The secret is sensitive and will be needed to decrypt the private key later, so it should be stored securely
    pub fn r_to_ciphertext(&self, secret: &str) -> Option<RPrivateKeyCiphertext> {
        if let Some(ciphertext) = Encryptor::encrypt_private_key_with_secret(self, secret).ok() {
            Some(RPrivateKeyCiphertext::from(ciphertext))
        } else {
            None
        }
    }

    /// Get private key from a private key ciphertext using a secret.
    pub fn r_from_private_key_ciphertext(
        ciphertext: &RPrivateKeyCiphertext,
        secret: &str,
    ) -> Option<RPrivateKey> {
        if let Some(private_key) =
            Encryptor::decrypt_private_key_with_secret(ciphertext, secret).ok()
        {
            Some(Self::from(private_key))
        } else {
            None
        }
    }
}

impl From<PrivateKeyNative> for RPrivateKey {
    fn from(private_key: PrivateKeyNative) -> Self {
        Self(private_key)
    }
}

impl From<RPrivateKey> for PrivateKeyNative {
    fn from(private_key: RPrivateKey) -> Self {
        private_key.0
    }
}

impl From<&RPrivateKey> for PrivateKeyNative {
    fn from(private_key: &RPrivateKey) -> Self {
        private_key.0
    }
}
impl FromStr for RPrivateKey {
    type Err = anyhow::Error;

    fn from_str(private_key: &str) -> Result<Self, Self::Err> {
        Ok(Self(PrivateKeyNative::from_str(private_key)?))
    }
}

impl fmt::Display for RPrivateKey {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Deref for RPrivateKey {
    type Target = PrivateKeyNative;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
