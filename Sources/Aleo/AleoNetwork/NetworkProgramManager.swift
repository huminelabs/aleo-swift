//
//  NetworkProgramManager.swift
//
//
//  Created by Nafeh Shoaib on 11/15/23.
//

import Foundation
import Observation
import os

@Observable
public class NetworkProgramManager<K: KeyProvider, R: RecordProvider> {
    public var account: Account?
    public var keyProvider: K
    public var host: String
    public var networkClient: NetworkClient
    
    public var recordProvider: R
    
    public init(account: Account? = nil, keyProvider: K, host: String, networkClient: NetworkClient, recordProvider: R) {
        // Test
        self.account = account
        self.keyProvider = keyProvider
        self.host = host
        self.networkClient = networkClient
        self.recordProvider = recordProvider
    }
        
    /**
     * Execute an Aleo program on the Aleo network
     *
     * @param {string} programName Program name containing the function to be executed
     * @param {string} functionName Function name to execute
     * @param {number} fee Fee to pay for the transaction
     * @param {boolean} privateFee Use a private record to pay the fee. If false this will use the account's public credit balance
     * @param {string[]} inputs Inputs to the function
     * @param {RecordSearchParams} recordSearchParams Optional parameters for searching for a record to pay the fee for
     * the execution transaction
     * @param {KeySearchParams} keySearchParams Optional parameters for finding the matching proving & verifying keys
     * for the function
     * @param {string | RecordPlaintext | undefined} feeRecord Optional Fee record to use for the transaction
     * @param {ProvingKey | undefined} provingKey Optional proving key to use for the transaction
     * @param {VerifyingKey | undefined} verifyingKey Optional verifying key to use for the transaction
     * @param {PrivateKey | undefined} privateKey Optional private key to use for the transaction
     * @param {OfflineQuery | undefined} offlineQuery Optional offline query if creating transactions in an offline environment
     * @returns {Promise<string | Error>}
     *
     * @example
     * // Create a new NetworkClient, KeyProvider, and RecordProvider using official Aleo record, key, and network providers
     * const networkClient = new AleoNetworkClient("https://vm.aleo.org/api");
     * const keyProvider = new AleoKeyProvider();
     * keyProvider.useCache = true;
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     *
     * // Initialize a program manager with the key provider to automatically fetch keys for executions
     * const programName = "hello_hello.aleo";
     * const programManager = new ProgramManager("https://vm.aleo.org/api", keyProvider, recordProvider);
     * const keySearchParams = { "cacheKey": "hello_hello:hello" };
     * const tx_id = await programManager.execute(programName, "hello_hello", 0.020, ["5u32", "5u32"], undefined, undefined, undefined, keySearchParams);
     * const transaction = await programManager.networkClient.getTransaction(tx_id);
     */
    public func execute(
        programName: String,
        functionName: String,
        fee: Int,
        privateFee: Bool,
        inputs: [String],
        recordSearchParams: RecordSearchParams? = nil,
        keySearchProverURL: URL? = nil,
        keySearchVerifierURL: URL? = nil,
        keySearchCacheKey: String? = nil,
        feeRecord: RecordPlaintext? = nil,
        provingKey: ProvingKey? = nil,
        verifyingKey: VerifyingKey? = nil,
        privateKey: PrivateKey? = nil
    ) async throws -> String {
        // Test
        guard let transaction = try await buildExecutionTransaction(programName: programName, functionName: functionName, fee: Float(fee), privateFee: privateFee, inputs: inputs, recordSearchParams: recordSearchParams, keySearchProverURL: keySearchProverURL, keySearchVerifierURL: keySearchVerifierURL, keySearchCacheKey: keySearchCacheKey, feeRecord: feeRecord, provingKey: provingKey, verifyingKey: verifyingKey, privateKey: privateKey) else {
            throw ProgramError.failedToFindProgram(programName)
        }
        
        return try await networkClient.submit(transaction: transaction)
    }
    
    /**
         * Build an execution transaction for later submission to the Aleo network.
         *
         * @param {string} programName Program name containing the function to be executed
         * @param {string} functionName Function name to execute
         * @param {number} fee Fee to pay for the transaction
         * @param {boolean} privateFee Use a private record to pay the fee. If false this will use the account's public credit balance
         * @param {string[]} inputs Inputs to the function
         * @param {RecordSearchParams} recordSearchParams Optional parameters for searching for a record to pay the fee for
         * the execution transaction
         * @param {KeySearchParams} keySearchParams Optional parameters for finding the matching proving & verifying keys
         * for the function
         * @param {string | RecordPlaintext | undefined} feeRecord Optional Fee record to use for the transaction
         * @param {ProvingKey | undefined} provingKey Optional proving key to use for the transaction
         * @param {VerifyingKey | undefined} verifyingKey Optional verifying key to use for the transaction
         * @param {PrivateKey | undefined} privateKey Optional private key to use for the transaction
         * @param {OfflineQuery | undefined} offlineQuery Optional offline query if creating transactions in an offline environment
         * @returns {Promise<string | Error>}
         *
         * @example
         * // Create a new NetworkClient, KeyProvider, and RecordProvider using official Aleo record, key, and network providers
         * const networkClient = new AleoNetworkClient("https://vm.aleo.org/api");
         * const keyProvider = new AleoKeyProvider();
         * keyProvider.useCache = true;
         * const recordProvider = new NetworkRecordProvider(account, networkClient);
         *
         * // Initialize a program manager with the key provider to automatically fetch keys for executions
         * const programName = "hello_hello.aleo";
         * const programManager = new ProgramManager("https://vm.aleo.org/api", keyProvider, recordProvider);
         * const keySearchParams = { "cacheKey": "hello_hello:hello" };
         * const transaction = await programManager.execute(programName, "hello_hello", 0.020, ["5u32", "5u32"], undefined, undefined, undefined, keySearchParams);
         * const result = await programManager.networkClient.submitTransaction(transaction);
         */
        func buildExecutionTransaction(
            programName: String,
            functionName: String,
            fee: Float,
            privateFee: Bool,
            inputs: [String],
            recordSearchParams: RecordSearchParams?,
            keySearchProverURL: URL? = nil,
            keySearchVerifierURL: URL? = nil,
            keySearchCacheKey: String? = nil,
            feeRecord: RecordPlaintext? = nil,
            provingKey: ProvingKey? = nil,
            verifyingKey: VerifyingKey? = nil,
            privateKey: PrivateKey? = nil
        ) async throws -> Transaction? {
            // Ensure the function exists on the network
            guard let program = try await networkClient.getProgram(programID: programName) else {
                throw ProgramError.failedToFindProgram(programName)
            }

            // Get the private key from the account if it is not provided in the parameters
            var executionPrivateKey: PrivateKey
            if let privateKey = privateKey {
                executionPrivateKey = privateKey
            } else if let account = account {
                executionPrivateKey = account.privateKey
            } else {
                throw ProgramError.noPrivateKey
            }

            // Get the fee record from the account if it is not provided in the parameters
            
            let newFeeRecord = try await recordProvider.findCreditsRecord(microcredits: fee, unspent: true, nonces: [], searchParameters: recordSearchParams)

            // Get the fee proving and verifying keys from the key provider
            let feeKeys = privateFee ? try await keyProvider.feePrivateKeys() : try await keyProvider.feePublicKeys()
            
            let (feeProvingKey, feeVerifyingKey) = feeKeys

            // If the function proving and verifying keys are not provided, attempt to find them using the key provider
            if let provingKey = provingKey,
               let verifyingKey = verifyingKey {
                
            } else {
                do {
                    let (provingKey, verifyingKey) = try await keyProvider.functionKeys(proverURL: keySearchProverURL, verifierURL: keySearchVerifierURL, cacheKey: keySearchCacheKey)
                } catch {
                    os_log("Function keys not found. Key finder response: \(error.localizedDescription). The function keys will be synthesized")
                }
            }

            // Resolve the program imports if they exist
            // TODO: Implement Imports
//            let imports = try await networkClient.getProgramImports(for: programName)
            
            // Build an execution transaction and submit it to the network
            return try await CoreProgramManager.execute(
                privateKey: executionPrivateKey,
                program: program,
                function: functionName,
                inputs: inputs,
                feeCredits: fee,
                feeRecord: newFeeRecord,
                url: host,
                imports: [:],
                provingKey: provingKey,
                verifyingKey: verifyingKey,
                feeProvingKey: feeProvingKey,
                feeVerifyingKey: feeVerifyingKey
            )
        }
}


enum ProgramError: Error, LocalizedError {
    case failedToFindProgram(String), noPrivateKey
    
    var errorDescription: String? {
        switch self {
        case .failedToFindProgram(let id):
            "Error finding \(id). Please ensure you're connected to a valid Aleo network the program is deployed to the network."
        case .noPrivateKey:
            "No private key provided and no private key set in the ProgramManager"
        }
    }
}
