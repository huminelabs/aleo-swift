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
    public init?(fromBytes bytes: UnsafeBufferPointer<UInt8>) {
        guard let rustVerifyingKey = RVerifyingKey.r_from_bytes(bytes) else {
            return nil
        }
        
        self.init(rustVerifyingKey: rustVerifyingKey)
    }
    
    /// Construct a new verifying key from a byte array
    ///
    /// - Parameter bytes: Byte representation of a verifying key
    public init?(fromBytes bytes: [UInt8]) {
        guard let rustVerifyingKey = bytes.withUnsafeBufferPointer({ pointer in
            RVerifyingKey.r_from_bytes(pointer)
        }) else {
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
        let rustVK = rustVerifyingKey.r_copy()
        return .init(rustVerifyingKey: rustVK)
    }
}

extension VerifyingKey {
    /// Returns the verifying key for the `bond_public` function
    public static var bondPublicVerifier: VerifyingKey { FunctionType.bondPublic.verifyingKey! }
    /// Returns the verifying key for the `claim_unbond` function
    public static var claimUnbondVerifier: VerifyingKey { FunctionType.claimUnbondPublic.verifyingKey! }
    /// Returns the verifying key for the `fee_private` function
    public static var feePrivateVerifier: VerifyingKey { FunctionType.feePrivate.verifyingKey! }
    /// Returns the verifying key for the `fee_public` function
    public static var feePublicVerifier: VerifyingKey { FunctionType.feePublic.verifyingKey! }
    /// Returns the verifying key for the `inclusion` function
    public static var inclusionVerifier: VerifyingKey { FunctionType.inclusion.verifyingKey! }
    /// Returns the verifying key for the `join` function
    public static var joinVerifier: VerifyingKey { FunctionType.join.verifyingKey! }
    /// Returns the verifying key for the `set_validator_state` function
    public static var setValidatorStateVerifier: VerifyingKey { FunctionType.setValidatorState.verifyingKey! }
    /// Returns the verifying key for the `split` function
    public static var splitVerifier: VerifyingKey { FunctionType.split.verifyingKey! }
    /// Returns the verifying key for the `transfer_private` function
    public static var transferPrivateVerifier: VerifyingKey { FunctionType.transferPrivate.verifyingKey! }
    /// Returns the verifying key for the `transfer_private_to_public` function
    public static var transferPrivateToPublicVerifier: VerifyingKey { FunctionType.transferPrivateToPublic.verifyingKey! }
    /// Returns the verifying key for the `transfer_public` function
    public static var transferPublicVerifier: VerifyingKey { FunctionType.transferPublic.verifyingKey! }
    /// Returns the verifying key for the `transfer_public_to_private` function
    public static var transferPublicToPrivateVerifier: VerifyingKey { FunctionType.transferPublicToPrivate.verifyingKey! }
    /// Returns the verifying key for the `unbond_delegator_as_validator` function
    public static var unbondDelegatorAsValidatorVerifier: VerifyingKey { FunctionType.unbondDelegatorAsValidator.verifyingKey! }
    /// Returns the verifying key for the `unbond_public` function
    public static var unbondPublicVerifier: VerifyingKey { FunctionType.unbondPublic.verifyingKey! }
}
