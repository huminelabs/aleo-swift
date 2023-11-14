//
//  Address+Helpers.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Public address of an Aleo account.
public struct Address: Equatable, LosslessStringConvertible {
    
    internal var rustAddress: RAddress
    
    internal init(rustAddress: RAddress) {
        self.rustAddress = rustAddress
    }
    
    /// Derive an Aleo address from a private key.
    ///
    /// - Parameter privateKey: The private key to derive the address from.
    public init(privateKey: PrivateKey) {
        self.init(rustAddress: .init(r_private_key: privateKey.rustPrivateKey))
    }
    
    /// Derive an Aleo address from a view key.
    ///
    /// - Parameter viewKey: The view key to derive the address from.
    public init(viewKey: ViewKey) {
        self.init(rustAddress: .init(r_view_key: viewKey.rustViewKey))
    }
    
    /// Create an aleo address object from a string representation of an address.
    ///
    /// - Parameter string: String representation of an address.
    public init(_ string: String) {
        self.init(rustAddress: .init(r_string: string))
    }
    
    public var description: String {
        toString()
    }
    
    /// Get a string representation of an Aleo address object.
    ///
    /// - Returns: String representation of the address.
    public func toString() -> String {
        rustAddress.r_to_string().toString()
    }
    
    /// Verify a signature for a message signed by the address.
    ///
    /// - Parameters:
    ///    - message: Byte array representing a message signed by the address.
    ///    - signature: Signature to verify message.
    /// - Returns: Whether or not the signature is valid
    public func verify(message: [UInt8], with signature: Signature) -> Bool {
        rustAddress.r_verify(message.withUnsafeBufferPointer { $0 }, signature.rustSignature)
    }
}
