//
//  PrivateKey.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Private key of an Aleo account.
public struct PrivateKey: Equatable, LosslessStringConvertible {
    
    internal var rustPrivateKey: RPrivateKey
    
    internal init(rustPrivateKey: RPrivateKey) {
        self.rustPrivateKey = rustPrivateKey
    }
    
    /// Generate a new private key using a cryptographically secure random number generator.
    public init() {
        self.rustPrivateKey = .init()
    }
    
    /// Get a private key from a series of unchecked bytes.
    ///
    /// - Parameter seed: Unchecked 32 byte long Uint8Array acting as the seed for the private key.
    public init(seed: [UInt8]) {
        self.init(rustPrivateKey: .init(r_seed: seed.withUnsafeBufferPointer { $0 }))
    }
    
    /// Get a private key from a string representation of a private key.
    ///
    /// - Parameter string: String representation of a private key.
    public init?(_ string: String) {
        guard let rustPrivateKey = RPrivateKey.r_from_string(string) else {
            return nil
        }
        
        self.init(rustPrivateKey: rustPrivateKey)
    }
    
    /// Get private key from a private key ciphertext and secret originally used to encrypt it.
    ///
    /// - Parameter ciphertext: Ciphertext representation of the private key.
    /// - Parameter secret: Secret originally used to encrypt the private key.
    public init?(ciphertext: PrivateKeyCiphertext, secret: String) {
        guard let rustPrivateKey = RPrivateKey.r_from_private_key_ciphertext(ciphertext.rustPrivateKeyCiphertext, secret) else {
            return nil
        }
        
        self.init(rustPrivateKey: rustPrivateKey)
    }
    
    public var description: String {
        toString()
    }
    
    /// Get a string representation of the private key.
    ///
    /// This function should be used very carefully as it exposes the private key plaintext.
    ///
    /// - Returns: String representation of a private key.
    public func toString() -> String {
        rustPrivateKey.r_to_string().toString()
    }
    
    /// Get the view key corresponding to the private key.
    public var viewKey: ViewKey {
        ViewKey(rustViewKey: rustPrivateKey.r_to_view_key())
    }
    
    /// Get the address corresponding to the private key.
    public var address: Address {
        Address(rustAddress: rustPrivateKey.r_to_address())
    }
    
    /// Sign a message with the private key.
    ///
    /// - Parameter message: Byte array representing a message signed by the address.
    /// - Returns: Signature generated by signing the message with the address.
    public func sign(message: [UInt8]) -> Signature {
        Signature(rustSignature: rustPrivateKey.r_sign(message.withUnsafeBufferPointer { $0 }))
    }
    
    /// Create a new randomly generated private key ciphertext using a secret.
    ///
    /// The secret is sensitive and will be needed to decrypt the private key later, so it should be stored securely.
    ///
    /// - Parameter secret: Secret used to encrypt the private key.
    /// - Returns: Ciphertext representation of the private key.
    public static func newEncrypted(secret: String) -> PrivateKeyCiphertext? {
        guard let ciphertext = RPrivateKey.r_new_encrypted(secret) else {
            return nil
        }
        
        return PrivateKeyCiphertext(rustPrivateKeyCiphertext: ciphertext)
    }
    
    /// Encrypt an existing private key with a secret.
    ///
    /// The secret is sensitive and will be needed to decrypt the private key later, so it should be stored securely.
    ///
    /// - Parameter secret: Secret used to encrypt the private key.
    /// - Returns: Ciphertext representation of the private key.
    public func toCiphertext(secret: String) -> PrivateKeyCiphertext? {
        guard let ciphertext = rustPrivateKey.r_to_ciphertext(secret) else {
            return nil
        }
        
        return PrivateKeyCiphertext(rustPrivateKeyCiphertext: ciphertext)
    }
}
