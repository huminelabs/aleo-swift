use crate::types::native::{
    CiphertextNative, CurrentNetwork, FieldNative, IdentifierNative, LiteralNative, Network,
    PlaintextNative, PrivateKeyNative, Uniform,
};

use once_cell::sync::OnceCell;
use std::str::FromStr;

/// Aleo Encryptor
pub struct Encryptor;

impl Encryptor {
    /// Encrypt a private key into ciphertext using a secret
    pub(crate) fn encrypt_private_key_with_secret(
        private_key: &PrivateKeyNative,
        secret: &str,
    ) -> Result<CiphertextNative, String> {
        Self::encrypt_field(&private_key.seed(), secret, "private_key")
    }

    /// Decrypt a private key from ciphertext using a secret
    pub(crate) fn decrypt_private_key_with_secret(
        ciphertext: &CiphertextNative,
        secret: &str,
    ) -> Result<PrivateKeyNative, String> {
        let seed = Self::decrypt_field(ciphertext, secret, "private_key")?;
        PrivateKeyNative::try_from(seed).map_err(|e| e.to_string())
    }

    // Encrypted a field element into a ciphertext representation
    fn encrypt_field(
        field: &FieldNative,
        secret: &str,
        domain: &str,
    ) -> Result<CiphertextNative, String> {
        // Derive the domain separators and the secret.
        let domain = FieldNative::new_domain_separator(domain);
        let secret = FieldNative::new_domain_separator(secret);

        // Generate a nonce
        let mut rng = rand::thread_rng();
        let nonce = Uniform::rand(&mut rng);

        // Derive a blinding factor and create an encryption target
        let blinding =
            CurrentNetwork::hash_psd2(&[domain, nonce, secret]).map_err(|e| e.to_string())?;
        let key = blinding * field;
        let plaintext = PlaintextNative::Struct(
            indexmap::IndexMap::from_iter(vec![
                (
                    IdentifierNative::from_str("key").map_err(|e| e.to_string())?,
                    PlaintextNative::from(LiteralNative::Field(key)),
                ),
                (
                    IdentifierNative::from_str("nonce").map_err(|e| e.to_string())?,
                    PlaintextNative::from(LiteralNative::Field(nonce)),
                ),
            ]),
            OnceCell::new(),
        );
        plaintext
            .encrypt_symmetric(secret)
            .map_err(|e| e.to_string())
    }

    // Recover a field element encrypted within ciphertext
    fn decrypt_field(
        ciphertext: &CiphertextNative,
        secret: &str,
        domain: &str,
    ) -> Result<FieldNative, String> {
        let domain = FieldNative::new_domain_separator(domain);
        let secret = FieldNative::new_domain_separator(secret);
        let decrypted = ciphertext
            .decrypt_symmetric(secret)
            .map_err(|e| e.to_string())?;
        let recovered_key = Self::extract_value(&decrypted, "key")?;
        let recovered_nonce = Self::extract_value(&decrypted, "nonce")?;
        let recovered_blinding = CurrentNetwork::hash_psd2(&[domain, recovered_nonce, secret])
            .map_err(|e| e.to_string())?;
        Ok(recovered_key / recovered_blinding)
    }

    // Extract a field element from a plaintext
    fn extract_value(plaintext: &PlaintextNative, identifier: &str) -> Result<FieldNative, String> {
        let identity = IdentifierNative::from_str(identifier).map_err(|e| e.to_string())?;
        let value = plaintext.find(&[identity]).map_err(|e| e.to_string())?;
        match value {
            PlaintextNative::Literal(literal, ..) => match literal {
                LiteralNative::Field(recovered_value) => Ok(recovered_value),
                _ => Err("Wrong literal type".to_string()),
            },
            _ => Err("Expected literal".to_string()),
        }
    }
}
