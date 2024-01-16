//
//  CreditProgramKeys.swift
//
//
//  Created by Nafeh Shoaib on 12/7/23.
//

import Foundation

struct CreditProgramKeys {
    var locator: String
    var prover: String
    var verifier: String
    var verifyingKey: VerifyingKey
    
    public static func from(verifier: String) -> CreditProgramKeys? {
        return CreditProgramKeys.knownKeys.first(where: { $0.verifier == verifier })
    }
    
    public static var knownKeys: [CreditProgramKeys] = [
        CreditProgramKeys.bondPublic,
        CreditProgramKeys.claimUnbondPublic,
        CreditProgramKeys.feePrivate,
        CreditProgramKeys.feePublic,
        CreditProgramKeys.inclusion,
        CreditProgramKeys.join,
        CreditProgramKeys.setValidatorState,
        CreditProgramKeys.split,
        CreditProgramKeys.transferPrivate,
        CreditProgramKeys.transferPrivateToPublic,
        CreditProgramKeys.transferPublic,
        CreditProgramKeys.transferPublicToPrivate,
        CreditProgramKeys.unbondDelegatorAsValidator,
        CreditProgramKeys.unbondPublic
    ]
    
    public static var privateTransferTypes = [
        "transfer_private",
        "private",
        "transferPrivate",
        "transfer_private_to_public",
        "privateToPublic",
        "transferPrivateToPublic",
    ]
    
    public static var validTransferTypes = [
        "transfer_private",
        "private",
        "transferPrivate",
        "transfer_private_to_public",
        "privateToPublic",
        "transferPrivateToPublic",
        "transfer_public",
        "public",
        "transferPublic",
        "transfer_public_to_private",
        "publicToPrivate",
        "transferPublicToPrivate",
    ]
    
    public static var privateTransfer = [
        "private",
        "transfer_private",
        "transferPrivate",
    ]
    
    public static var privateToPublicTransfer = [
        "private_to_public",
        "privateToPublic",
        "transfer_private_to_public",
        "transferPrivateToPublic",
    ]
    
    public static var publicTransfer = [
        "public",
        "transfer_public",
        "transferPublic",
    ]
    
    public static var publicToPrivateTransfer = [
        "public_to_private",
        "publicToPrivate",
        "transfer_public_to_private",
        "transferPublicToPrivate",
    ]
    
    public static var bondPublic = CreditProgramKeys(
        locator: "credits.aleo/bond_public",
        prover: NetworkKeyProvider.keyStoreURI + "bond_public.prover.9c3547d",
        verifier: "bond_public.verifier.10315ae",
        verifyingKey: VerifyingKey.bondPublicVerifier
    )
    public static var claimUnbondPublic = CreditProgramKeys(
        locator: "credits.aleo/claim_unbond_public",
        prover: NetworkKeyProvider.keyStoreURI + "claim_unbond_public.prover.f8b64aa",
        verifier: "claim_unbond_public.verifier.8fd7445",
        verifyingKey: VerifyingKey.claimUnbondVerifier
    )
    public static var feePrivate = CreditProgramKeys(
        locator: "credits.aleo/fee_private",
        prover: NetworkKeyProvider.keyStoreURI + "fee_private.prover.43fab98",
        verifier: "fee_private.verifier.f3dfefc",
        verifyingKey: VerifyingKey.feePrivateVerifier
    )
    public static var feePublic = CreditProgramKeys(
        locator: "credits.aleo/fee_public",
        prover: NetworkKeyProvider.keyStoreURI + "fee_public.prover.634f153",
        verifier: "fee_public.verifier.09eeb4f",
        verifyingKey: VerifyingKey.feePublicVerifier
    )
    public static var inclusion = CreditProgramKeys(
        locator: "inclusion",
        prover: NetworkKeyProvider.keyStoreURI + "inclusion.prover.cd85cc5",
        verifier: "inclusion.verifier.e6f3add",
        verifyingKey: VerifyingKey.inclusionVerifier
    )
    public static var join = CreditProgramKeys(
        locator: "credits.aleo/join",
        prover: NetworkKeyProvider.keyStoreURI + "join.prover.1a76fe8",
        verifier: "join.verifier.4f1701b",
        verifyingKey: VerifyingKey.joinVerifier
    )
    public static var setValidatorState = CreditProgramKeys(
        locator: "credits.aleo/set_validator_state",
        prover: NetworkKeyProvider.keyStoreURI + "set_validator_state.prover.5ce19be",
        verifier: "set_validator_state.verifier.730d95b",
        verifyingKey: VerifyingKey.setValidatorStateVerifier
    )
    public static var split = CreditProgramKeys(
        locator: "credits.aleo/split",
        prover: NetworkKeyProvider.keyStoreURI + "split.prover.e6d12b9",
        verifier: "split.verifier.2f9733d",
        verifyingKey: VerifyingKey.splitVerifier
    )
    public static var transferPrivate = CreditProgramKeys(
        locator: "credits.aleo/transfer_private",
        prover: NetworkKeyProvider.keyStoreURI + "transfer_private.prover.2b487c0",
        verifier: "transfer_private.verifier.3a3cbba",
        verifyingKey: VerifyingKey.transferPrivateVerifier
    )
    public static var transferPrivateToPublic = CreditProgramKeys(
        locator: "credits.aleo/transfer_private_to_public",
        prover: NetworkKeyProvider.keyStoreURI + "transfer_private_to_public.prover.1ff64cb",
        verifier: "transfer_private_to_public.verifier.d5b60de",
        verifyingKey: VerifyingKey.transferPrivateToPublicVerifier
    )
    public static var transferPublic = CreditProgramKeys(
        locator: "credits.aleo/transfer_public",
        prover: NetworkKeyProvider.keyStoreURI + "transfer_public.prover.a74565e",
        verifier: "transfer_public.verifier.a4c2906",
        verifyingKey: VerifyingKey.transferPublicVerifier
    )
    public static var transferPublicToPrivate = CreditProgramKeys(
        locator: "credits.aleo/transfer_public_to_private",
        prover: NetworkKeyProvider.keyStoreURI + "transfer_public_to_private.prover.1bcddf9",
        verifier: "transfer_public_to_private.verifier.b094554",
        verifyingKey: VerifyingKey.transferPublicToPrivateVerifier
    )
    public static var unbondDelegatorAsValidator = CreditProgramKeys(
        locator: "credits.aleo/unbond_delegator_as_validator",
        prover: NetworkKeyProvider.keyStoreURI + "unbond_delegator_as_validator.prover.115a86b",
        verifier: "unbond_delegator_as_validator.verifier.9585609",
        verifyingKey: VerifyingKey.unbondDelegatorAsValidatorVerifier
    )
    public static var unbondPublic = CreditProgramKeys(
        locator: "credits.aleo/unbond_public",
        prover: NetworkKeyProvider.keyStoreURI + "unbond_public.prover.9547c05",
        verifier: "unbond_public.verifier.09873cd",
        verifyingKey: VerifyingKey.unbondPublicVerifier
    )
}
