//
//  KeyPair.swift
//
//
//  Created by Nafeh Shoaib on 11/10/23.
//

import Foundation

public struct KeyPair {
    internal var rustKeyPair: RKeyPair
    
    internal init(rustKeyPair: RKeyPair) {
        self.rustKeyPair = rustKeyPair
    }
    
    /// Create new key pair from proving and verifying keys
    ///
    /// - Parameters:
    ///     - provingKey: Proving key corresponding to a function in an Aleo program
    ///     - verifyingKey: Verifying key corresponding to a function in an Aleo program
    public init(provingKey: ProvingKey, verifyingKey: VerifyingKey) {
        self.init(rustKeyPair: .init(provingKey.rustProvingKey, verifyingKey.rustVerifyingKey))
    }
    
    /// Get the proving key. This method will remove the proving key from the key pair
    public var provingKey: ProvingKey? {
        guard let rProvingKey = rustKeyPair.r_proving_key() else {
            return nil
        }
        
        return ProvingKey(rustProvingKey: rProvingKey)
    }
    
    /// Get the verifying key. This method will remove the verifying key from the key pair
    public var verifyingKey: VerifyingKey? {
        guard let rVerifyingKey = rustKeyPair.r_verifying_key() else {
            return nil
        }
        
        return VerifyingKey(rustVerifyingKey: rVerifyingKey)
    }
}
