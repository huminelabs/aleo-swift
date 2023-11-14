//
//  PrivateKeyCiphertext.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Private Key in ciphertext form.
public struct PrivateKeyCiphertext: Equatable, LosslessStringConvertible {
    
    internal var rustPrivateKeyCiphertext: RPrivateKeyCiphertext
    
    internal init(rustPrivateKeyCiphertext: RPrivateKeyCiphertext) {
        self.rustPrivateKeyCiphertext = rustPrivateKeyCiphertext
    }
    
    /// Encrypt a private key using a secret string.
    ///
    /// The secret is sensitive and will be needed to decrypt the private key later, so it should be stored securely.
    ///
    /// - Parameter privateKey Private key to encrypt.
    /// - Parameter secret: Secret to encrypt the private key with.
    public init?(privateKey: PrivateKey, secret: String) {
        guard let rustPrivateKeyCiphertext = RPrivateKeyCiphertext.r_encrypt_private_key(privateKey.rustPrivateKey, secret) else {
            return nil
        }
        
        self.init(rustPrivateKeyCiphertext: rustPrivateKeyCiphertext)
    }
    
    /// Creates a PrivateKeyCiphertext from a string.
    ///
    /// - Parameter string: Ciphertext string.
    public init?(_ string: String) {
        guard let rustPrivateKeyCiphertext = RPrivateKeyCiphertext.r_from_string(string) else {
            return nil
        }
        
        self.init(rustPrivateKeyCiphertext: rustPrivateKeyCiphertext)
    }
    
    public var description: String {
        toString()
    }
    
    /// Returns the ciphertext string.
    ///
    /// - Returns: Ciphertext string.
    public func toString() -> String {
        rustPrivateKeyCiphertext.r_to_string().toString()
    }
    
    /// Decrypts a private ciphertext using a secret string.
    ///
    /// This must be the same secret used to encrypt the private key.
    ///
    /// - Parameter secret: Secret used to encrypt the private key.
    /// - Returns: Private key
    public func decryptToPrivateKey(using secret: String) -> PrivateKey? {
        guard let privateKey = rustPrivateKeyCiphertext.r_decrypt_to_private_key(secret) else {
            return nil
        }
        
        return PrivateKey(rustPrivateKey: privateKey)
    }
}
