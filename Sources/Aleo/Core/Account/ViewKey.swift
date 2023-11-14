//
//  ViewKey.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

public struct ViewKey: Equatable, LosslessStringConvertible {
    
    internal var rustViewKey: RViewKey
    
    internal init(rustViewKey: RViewKey) {
        self.rustViewKey = rustViewKey
    }
    
    /// Create a new view key from a private key.
    ///
    /// - Parameter privateKey: Private key.
    public init(privateKey: PrivateKey) {
        self.init(rustViewKey: .init(r_private_key: privateKey.rustPrivateKey))
    }
    
    /// Create a new view key from a string representation of a view key.
    ///
    /// - Parameter viewKey: String representation of a view key.
    public init(_ string: String) {
        self.init(rustViewKey: .init(r_view_key_string: string))
    }
    
    public var description: String {
        toString()
    }
    
    /// Get a string representation of a view key.
    ///
    /// - Returns: String representation of a view key.
    public func toString() -> String {
        return rustViewKey.r_to_string().toString()
    }
    
    /// Get the address corresponding to a view key.
    public var address: Address {
        return Address(rustAddress: rustViewKey.r_to_address())
    }
    
    /// Decrypt a record ciphertext with a view key.
    ///
    /// - Parameter ciphertext: String representation of a record ciphertext.
    /// - Returns: String representation of a record plaintext.
    public func decrypt(ciphertext: String) -> String? {
        return rustViewKey.r_decrypt(ciphertext)?.toString()
    }
}
