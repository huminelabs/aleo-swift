//
//  ProvingKey.swift
//
//
//  Created by Nafeh Shoaib on 11/10/23.
//

import Foundation

/// Proving key for a function within an Aleo program
public struct ProvingKey {
    
    internal var rustProvingKey: RProvingKey
    
    internal init(rustProvingKey: RProvingKey) {
        self.rustProvingKey = rustProvingKey
    }
    
    /// Construct a new proving key from a byte array
    ///
    /// - Parameter bytes: Byte array representation of a proving key
    public init?(fromBytes bytes: [UInt8]) {
        guard let rustProvingKey = RProvingKey.r_from_bytes(bytes.withUnsafeBufferPointer { $0 }) else {
            return nil
        }
        
        self.init(rustProvingKey: rustProvingKey)
    }
    
    /// Return the byte representation of a proving key
    ///
    /// - Returns: Byte array representation of a proving key
    public func toBytes() -> [UInt8]? {
        guard let vector = rustProvingKey.r_to_bytes() else {
            return nil
        }
        
        return Array(vector)
    }
    
    /// Create a copy of the proving key
    ///
    /// - Returns: A copy of the proving key
    public func copy() -> ProvingKey {
        var rustPK = rustProvingKey.r_copy()
        return .init(rustProvingKey: rustPK)
    }
}

