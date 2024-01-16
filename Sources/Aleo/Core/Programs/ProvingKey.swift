//
//  ProvingKey.swift
//
//
//  Created by Nafeh Shoaib on 11/10/23.
//

import Foundation

/// Proving key for a function within an Aleo program
public struct ProvingKey: LosslessStringConvertible {
    
    internal var rustProvingKey: RProvingKey
    
    public var description: String {
        toString()
    }
    
    internal init(rustProvingKey: RProvingKey) {
        self.rustProvingKey = rustProvingKey
    }
    
    /// Create a new proving key from string
    ///
    /// - Parameter string: String representation of a verifying key
    public init?(_ string: String) {
        guard let rustProvingKey = RProvingKey.r_from_string(string) else {
            return nil
        }
        
        self.init(rustProvingKey: rustProvingKey)
    }
    
    /// Construct a new proving key from a byte array
    ///
    /// - Parameter bytes: Byte array representation of a proving key
    public init?(fromBytes bytes: UnsafeBufferPointer<UInt8>) {
        guard let rustProvingKey = RProvingKey.r_from_bytes(bytes) else {
            return nil
        }
        
        self.init(rustProvingKey: rustProvingKey)
    }
    
    /// Construct a new proving key from a byte array
    ///
    /// - Parameter bytes: Byte array representation of a proving key
    public init?(fromBytes bytes: [UInt8]) {
        guard let rustProvingKey = bytes.withUnsafeBufferPointer({ pointer in
            return RProvingKey.r_from_bytes(pointer)
        }) else {
            return nil
        }
        
        self.init(rustProvingKey: rustProvingKey)
    }
    
    /// Construct a new proving key from a `Data` object
    ///
    /// - Parameter bytes: Data representation of a proving key
    public init?(_ data: Data) {
        guard let rustProvingKey = data.withUnsafeBytes({ unsafeBytes in
            let pointer = unsafeBytes.bindMemory(to: UInt8.self)
            return RProvingKey.r_from_bytes(pointer)
        }) else {
            return nil
        }
        
        self.init(rustProvingKey: rustProvingKey)
    }
    
    /// Get a string representation of the verifying key
    ///
    /// - Returns: String representation of the verifying key
    public func toString() -> String {
        rustProvingKey.r_to_string().toString()
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
    
    /// Return the data representation of a proving key
    ///
    /// - Returns: Data representation of a proving key
    public func toData() -> Data? {
        guard let data = rustProvingKey.r_to_bytes() else {
            return nil
        }
        
        return Data(bytesNoCopy: data.ptr, count: data.count, deallocator: .none)
    }
    
    /// Create a copy of the proving key
    ///
    /// - Returns: A copy of the proving key
    public func copy() -> ProvingKey {
        let rustPK = rustProvingKey.r_copy()
        return .init(rustProvingKey: rustPK)
    }
    
    /// Checks if prover is for known functions
    public var functionType: FunctionType { .from(self) }
}
