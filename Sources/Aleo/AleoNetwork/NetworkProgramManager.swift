////
////  ProgramManager.swift
////
////
////  Created by Nafeh Shoaib on 11/15/23.
////
//
//import Foundation
//import Observation
//
//@Observable
//public class ProgramManager<F: FunctionKeyProvider, R: RecordProvider> {
//    public var account: Account?
//    public var keyProvider: F
//    public var host: String
//    public var cloudClient: AleoCloudClient
//    
//    public var recordProvider: R
//    
//    /**
//     * Execute an Aleo program on the Aleo network
//     *
//     * @param {string} programName Program name containing the function to be executed
//     * @param {string} functionName Function name to execute
//     * @param {number} fee Fee to pay for the transaction
//     * @param {boolean} privateFee Use a private record to pay the fee. If false this will use the account's public credit balance
//     * @param {string[]} inputs Inputs to the function
//     * @param {RecordSearchParams} recordSearchParams Optional parameters for searching for a record to pay the fee for
//     * the execution transaction
//     * @param {KeySearchParams} keySearchParams Optional parameters for finding the matching proving & verifying keys
//     * for the function
//     * @param {string | RecordPlaintext | undefined} feeRecord Optional Fee record to use for the transaction
//     * @param {ProvingKey | undefined} provingKey Optional proving key to use for the transaction
//     * @param {VerifyingKey | undefined} verifyingKey Optional verifying key to use for the transaction
//     * @param {PrivateKey | undefined} privateKey Optional private key to use for the transaction
//     * @param {OfflineQuery | undefined} offlineQuery Optional offline query if creating transactions in an offline environment
//     * @returns {Promise<string | Error>}
//     *
//     * @example
//     * // Create a new NetworkClient, KeyProvider, and RecordProvider using official Aleo record, key, and network providers
//     * const networkClient = new AleoNetworkClient("https://vm.aleo.org/api");
//     * const keyProvider = new AleoKeyProvider();
//     * keyProvider.useCache = true;
//     * const recordProvider = new NetworkRecordProvider(account, networkClient);
//     *
//     * // Initialize a program manager with the key provider to automatically fetch keys for executions
//     * const programName = "hello_hello.aleo";
//     * const programManager = new ProgramManager("https://vm.aleo.org/api", keyProvider, recordProvider);
//     * const keySearchParams = { "cacheKey": "hello_hello:hello" };
//     * const tx_id = await programManager.execute(programName, "hello_hello", 0.020, ["5u32", "5u32"], undefined, undefined, undefined, keySearchParams);
//     * const transaction = await programManager.networkClient.getTransaction(tx_id);
//     */
//    public func execute(
//        programName: String,
//        functionName: String,
//        fee: Int,
//        privateFee: Bool,
//        inputs: [String],
//        recordSearchParams: RecordSearchParams?,
//        keySearchParams: [String: String]?,
//        feeRecord: RecordPlaintext?,
//        provingKey: ProvingKey?,
//        verifyingKey: VerifyingKey?,
//        privateKey: PrivateKey?
//    ) async throws -> String {
//        let tx = try await buildExecutionTransaction(programName, functionName, fee, privateFee, inputs, recordSearchParams, keySearchParams, feeRecord, provingKey, verifyingKey, privateKey, offlineQuery);
//        return await cloudClient.submit(transaction: tx);
//    }
//    
//    /**
//         * Build an execution transaction for later submission to the Aleo network.
//         *
//         * @param {string} programName Program name containing the function to be executed
//         * @param {string} functionName Function name to execute
//         * @param {number} fee Fee to pay for the transaction
//         * @param {boolean} privateFee Use a private record to pay the fee. If false this will use the account's public credit balance
//         * @param {string[]} inputs Inputs to the function
//         * @param {RecordSearchParams} recordSearchParams Optional parameters for searching for a record to pay the fee for
//         * the execution transaction
//         * @param {KeySearchParams} keySearchParams Optional parameters for finding the matching proving & verifying keys
//         * for the function
//         * @param {string | RecordPlaintext | undefined} feeRecord Optional Fee record to use for the transaction
//         * @param {ProvingKey | undefined} provingKey Optional proving key to use for the transaction
//         * @param {VerifyingKey | undefined} verifyingKey Optional verifying key to use for the transaction
//         * @param {PrivateKey | undefined} privateKey Optional private key to use for the transaction
//         * @param {OfflineQuery | undefined} offlineQuery Optional offline query if creating transactions in an offline environment
//         * @returns {Promise<string | Error>}
//         *
//         * @example
//         * // Create a new NetworkClient, KeyProvider, and RecordProvider using official Aleo record, key, and network providers
//         * const networkClient = new AleoNetworkClient("https://vm.aleo.org/api");
//         * const keyProvider = new AleoKeyProvider();
//         * keyProvider.useCache = true;
//         * const recordProvider = new NetworkRecordProvider(account, networkClient);
//         *
//         * // Initialize a program manager with the key provider to automatically fetch keys for executions
//         * const programName = "hello_hello.aleo";
//         * const programManager = new ProgramManager("https://vm.aleo.org/api", keyProvider, recordProvider);
//         * const keySearchParams = { "cacheKey": "hello_hello:hello" };
//         * const transaction = await programManager.execute(programName, "hello_hello", 0.020, ["5u32", "5u32"], undefined, undefined, undefined, keySearchParams);
//         * const result = await programManager.networkClient.submitTransaction(transaction);
//         */
//        func buildExecutionTransaction(
//            programName: String,
//            functionName: String,
//            fee: Int,
//            privateFee: Bool,
//            inputs: [String],
//            recordSearchParams: RecordSearchParams?,
//            keySearchParams: [String: String]?,
//            feeRecord: RecordPlaintext?,
//            provingKey: ProvingKey?,
//            verifyingKey: VerifyingKey?,
//            privateKey: PrivateKey?
//        ) async throws -> Transaction {
//            // Ensure the function exists on the network
//            guard let program = try await cloudClient.getProgram(programID: programName) else {
//                throw ProgramError.failedToFindProgram(programName)
//            }
//
//            // Get the private key from the account if it is not provided in the parameters
//            var executionPrivateKey: PrivateKey
//            if let privateKey = privateKey {
//                executionPrivateKey = privateKey
//            } else if let account = account {
//                executionPrivateKey = account.privateKey
//            } else {
//                throw ProgramError.noPrivateKey
//            }
//
//            // Get the fee record from the account if it is not provided in the parameters
//            
//            let newFeeRecord = privateFee ? try await getCreditsRecord(fee, [], feeRecord, recordSearchParams) : nil;
//
//            // Get the fee proving and verifying keys from the key provider
//            let feeKeys = privateFee ? try await keyProvider.feePrivateKeys() : try await keyProvider.feePublicKeys()
//            
//            let (feeProvingKey, feeVerifyingKey) = feeKeys;
//
//            // If the function proving and verifying keys are not provided, attempt to find them using the key provider
//            if (!provingKey || !verifyingKey) {
//                try {
//                    [provingKey, verifyingKey] = <FunctionKeyPair>await this.keyProvider.functionKeys(keySearchParams);
//                } catch (e) {
//                    console.log(`Function keys not found. Key finder response: '${e}'. The function keys will be synthesized`)
//                }
//            }
//
//            // Resolve the program imports if they exist
//            let imports = try await cloudClient.getProgramImports(for: programName)
//            
//            // Build an execution transaction and submit it to the network
//            return await WasmProgramManager.buildExecutionTransaction(executionPrivateKey, program, functionName, inputs, fee, feeRecord, this.host, imports, provingKey, verifyingKey, feeProvingKey, feeVerifyingKey, offlineQuery);
//        }
//}
//
//
//enum ProgramError: Error, LocalizedError {
//    case failedToFindProgram(String), noPrivateKey
//    
//    var errorDescription: String? {
//        switch self {
//        case .failedToFindProgram(let id):
//            "Error finding \(id). Please ensure you're connected to a valid Aleo network the program is deployed to the network."
//        case .noPrivateKey:
//            "No private key provided and no private key set in the ProgramManager"
//        }
//    }
//}
