//
//  VerifyingKey.swift
//
//
//  Created by Nafeh Shoaib on 11/10/23.
//

import Foundation

/// Verifying key for a function within an Aleo program
public struct VerifyingKey: LosslessStringConvertible {
    
    internal var rustVerifyingKey: RVerifyingKey
    
    public var description: String {
        toString()
    }
    
    internal init(rustVerifyingKey: RVerifyingKey) {
        self.rustVerifyingKey = rustVerifyingKey
    }
    
    /// Create a verifying key from string
    ///
    /// - Parameter string: String representation of a verifying key
    public init?(_ string: String) {
        guard let rustVerifyingKey = RVerifyingKey.r_from_string(string) else {
            return nil
        }
        
        self.init(rustVerifyingKey: rustVerifyingKey)
    }
    
    /// Construct a new verifying key from a byte array
    ///
    /// - Parameter bytes: Byte representation of a verifying key
    public init?(fromBytes bytes: [UInt8]) {
        guard let rustVerifyingKey = RVerifyingKey.r_from_bytes(bytes.withUnsafeBufferPointer { $0 }) else {
            return nil
        }
        
        self.init(rustVerifyingKey: rustVerifyingKey)
    }
    
    /// Get a string representation of the verifying key
    ///
    /// - Returns: String representation of the verifying key
    public func toString() -> String {
        rustVerifyingKey.r_to_string().toString()
    }
    
    /// Create a byte array from a verifying key
    ///
    /// - Returns: Byte representation of a verifying key
    public func toBytes() -> [UInt8]? {
        guard let vector = rustVerifyingKey.r_to_bytes() else {
            return nil
        }
        
        return Array(vector)
    }
    
    /// Create a copy of the verifying key
    public func copy() -> VerifyingKey {
        var rustVK = rustVerifyingKey.r_copy()
        return .init(rustVerifyingKey: rustVK)
    }
}
