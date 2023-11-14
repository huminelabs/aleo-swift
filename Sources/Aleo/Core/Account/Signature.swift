//
//  Signature.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Cryptographic signature of a message signed by an Aleo account.
public struct Signature: LosslessStringConvertible {
    
    internal var rustSignature: RSignature
    
    internal init(rustSignature: RSignature) {
        self.rustSignature = rustSignature
    }
    
    /// Sign a message with a private key.
    ///
    /// - Parameter privateKey: The private key to sign the message with.
    /// - Parameter message: Byte representation of the message to sign.
    public init(privateKey: PrivateKey, message: [UInt8]) {
        self.init(rustSignature: .init(r_sign_init: privateKey.rustPrivateKey, message.withUnsafeBufferPointer { $0 }))
    }
    
    /// Get a signature from a string representation of a signature.
    ///
    /// - Parameter string: String representation of a signature.
    public init(_ string: String) {
        self.init(rustSignature: .init(r_from_string_init: string))
    }
    
    public var description: String {
        toString()
    }
    
    /// Verify a signature of a message with an address.
    ///
    /// - Parameter address: The address to verify the signature with.
    /// - Parameter message: Byte representation of the message to verify.
    /// - Returns: True if the signature is valid, false otherwise.
    public func verify(address: Address, message: [UInt8]) -> Bool {
        return rustSignature.r_verify(address.rustAddress, message.withUnsafeBufferPointer { $0 })
    }
    
    /// Get a string representation of a signature.
    ///
    /// - Returns: String representation of a signature.
    public func toString() -> String {
        return rustSignature.r_to_string().toString()
    }
}
