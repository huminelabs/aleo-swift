//
//  FunctionType.swift
//  
//
//  Created by Nafeh Shoaib on 11/24/23.
//

import Foundation

/// Known functions
public enum FunctionType {
    /// `bond_public` function
    case bondPublic
    /// `claim_unbond` function
    case claimUnbondPublic
    /// `fee_private` function
    case feePrivate
    /// `fee_public` function
    case feePublic
    /// Proving key is for the `inclusion` function
    case inclusion
    /// `join` function
    case join
    /// `set_validator_state` function
    case setValidatorState
    /// `split` function
    case split
    /// `transfer_private` function
    case transferPrivate
    /// `transfer_private_to_public` function
    case transferPrivateToPublic
    /// `transfer_public` function
    case transferPublic
    /// `transfer_public_to_private` function
    case transferPublicToPrivate
    /// `unbond_delegator_as_validator` function
    case unbondDelegatorAsValidator
    /// `unbond_public` function
    case unbondPublic
    /// Unknown function
    case other
    
    /// Checks proving key for known functions using internal rust derived type
    public static func from(_ provingKey: ProvingKey) -> Self {
        let rustProvingKey = provingKey.rustProvingKey
        
        if rustProvingKey.r_is_bond_public_prover() {
            return .bondPublic
        }
        
        if rustProvingKey.r_is_claim_unbond_public_prover() {
            return .claimUnbondPublic
        }
        
        if rustProvingKey.r_is_fee_private_prover() {
            return .feePrivate
        }
        
        if rustProvingKey.r_is_fee_public_prover() {
            return .feePublic
        }
        
        if rustProvingKey.r_is_inclusion_prover() {
            return .inclusion
        }
        
        if rustProvingKey.r_is_join_prover() {
            return .join
        }
        
        if rustProvingKey.r_is_set_validator_state_prover() {
            return .setValidatorState
        }
        
        if rustProvingKey.r_is_split_prover() {
            return .split
        }
        
        if rustProvingKey.r_is_transfer_private_prover() {
            return .transferPrivate
        }
        
        if rustProvingKey.r_is_transfer_private_to_public_prover() {
            return .transferPrivateToPublic
        }
        
        if rustProvingKey.r_is_transfer_public_prover() {
            return .transferPublic
        }
        
        if rustProvingKey.r_is_transfer_public_to_private_prover() {
            return .transferPublicToPrivate
        }
        
        if rustProvingKey.r_is_unbond_delegator_as_validator_prover() {
            return .unbondDelegatorAsValidator
        }
        
        if rustProvingKey.r_is_unbond_public_prover() {
            return .unbondPublic
        }
        
        return .other
    }
    
    public func from(_ verifyingKey: VerifyingKey) -> Self {
        let rustVerifyingKey = verifyingKey.rustVerifyingKey
        
        if rustVerifyingKey.r_is_bond_public_verifier() {
            return .bondPublic
        }
        
        if rustVerifyingKey.r_is_claim_unbond_public_verifier() {
            return .claimUnbondPublic
        }
        
        if rustVerifyingKey.r_is_fee_private_verifier() {
            return .feePrivate
        }
        
        if rustVerifyingKey.r_is_fee_public_verifier() {
            return .feePublic
        }
        
        if rustVerifyingKey.r_is_inclusion_verifier() {
            return .inclusion
        }
        
        if rustVerifyingKey.r_is_join_verifier() {
            return .join
        }
        
        if rustVerifyingKey.r_is_set_validator_state_verifier() {
            return .setValidatorState
        }
        
        if rustVerifyingKey.r_is_split_verifier() {
            return .split
        }
        
        if rustVerifyingKey.r_is_transfer_private_verifier() {
            return .transferPrivate
        }
        
        if rustVerifyingKey.r_is_transfer_private_to_public_verifier() {
            return .transferPrivateToPublic
        }
        
        if rustVerifyingKey.r_is_transfer_public_verifier() {
            return .transferPublic
        }
        
        if rustVerifyingKey.r_is_transfer_public_to_private_verifier() {
            return .transferPublicToPrivate
        }
        
        if rustVerifyingKey.r_is_unbond_delegator_as_validator_verifier() {
            return .unbondDelegatorAsValidator
        }
        
        if rustVerifyingKey.r_is_unbond_public_verifier() {
            return .unbondPublic
        }
        
        return .other
    }
    
    /// Returns the verifying key for the function, if known function,
    public var verifyingKey: VerifyingKey? {
        guard let rustVerifyingKey = rustVerifyingKey else {
            return nil
        }
        
        return VerifyingKey(rustVerifyingKey: rustVerifyingKey)
    }
    
    internal var rustVerifyingKey: RVerifyingKey? {
        switch self {
        case .bondPublic:
            .r_bond_public_verifier()
        case .claimUnbondPublic:
            .r_claim_unbond_public_verifier()
        case .feePrivate:
            .r_fee_private_verifier()
        case .feePublic:
            .r_fee_public_verifier()
        case .inclusion:
            .r_inclusion_verifier()
        case .join:
            .r_join_verifier()
        case .setValidatorState:
            .r_set_validator_state_verifier()
        case .split:
            .r_split_verifier()
        case .transferPrivate:
            .r_transfer_private_verifier()
        case .transferPrivateToPublic:
            .r_transfer_private_to_public_verifier()
        case .transferPublic:
            .r_transfer_public_verifier()
        case .transferPublicToPrivate:
            .r_transfer_public_to_private_verifier()
        case .unbondDelegatorAsValidator:
            .r_unbond_delegator_as_validator_verifier()
        case .unbondPublic:
            .r_unbond_public_verifier()
        case .other:
            nil
        }
    }
}
