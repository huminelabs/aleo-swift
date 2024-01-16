//
//  RecordProvider.swift
//  
//
//  Created by Nafeh Shoaib on 11/15/23.
//

import Foundation

public struct RecordSearchParams {
    var startHeight: Int?
    var endHeight: Int?
}

public protocol RecordProvider {
    var account: Account { get set }

    /**
     * Find a `credits.aleo` record with a given number of microcredits from the chosen provider
     *
     * - Parameters:
     *      - microcredits: The number of microcredits to search for
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: The record if found, otherwise an error
     *
     * A class implementing record provider can be used to find a record with a given number of microcredits
     * ```swift
     * let record = try await recordProvider.findCreditsRecord(microcredits: 5000, unspent: true)
     * ```
     *
     * When a record is found but not yet used, its nonce should be added to the nonces array so that it is not found again if a subsequent search is performed
     * ```swift
     * let record2 = try await recordProvider.findCreditsRecord(microcredits: 5000, unspent: true, nonces: [record.nonce])
     * ```
     *
     * When the program manager is initialized with the record provider it will be used to find automatically find fee records and amount records for value transfers so that they do not need to be specified manually
     * ```swift
     * let programManager = ProgramManager(host: "https://api.explorer.aleo.org/v1", keyProvider: keyProvider, recordProvider: recordProvider)
     * programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5)
     * ```
     */
    func findCreditsRecord(microcredits: Int, unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext

    /**
     * Find a list of `credit.aleo` records with a given number of microcredits from the chosen provider
     *
     * - Parameters:
     *      - microcreditAmounts: A list of separate microcredit amounts to search for (e.g. [5000, 100000])
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so that they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: A list of records with a value greater or equal to the amounts specified if such records exist, otherwise an error
     *
     *
     * A class implementing record provider can be used to find a record with a given number of microcredits
     * ```swift
     * let records = try await recordProvider.findCreditsRecords(microcredits: [5000, 5000], unspent: true, searchParameters: nil)
     * ```
     *
     * When a record is found but not yet used, it's nonce should be added to the nonces array so that it is not found again if a subsequent search is performed
     * ```swift
     * let nonces: [String] = []
     * records.map { record in nonces.push(record.nonce) }
     * let records2 = try await recordProvider.findCreditsRecord(microcredits: 5000, unspent: true, nonces: nonces)
     * ```
     *
     * When the program manager is initialized with the record provider it will be used to find automatically find fee records and amount records for value transfers so that they do not need to be specified manually
     * ```swift
     * let programManager = ProgramManager(host: "https://api.explorer.aleo.org/v1", keyProvider: keyProvider, recordProvider: recordProvider)
     * programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5)
     * ```
     */
    func findCreditsRecords(microcredits: [Int], unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> [RecordPlaintext]

    /**
     * Find an arbitrary record
     * - Parameters:
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so that they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: The record if found, otherwise an error
     *
     * The `RecordSearchParams` interface can be used to create parameters for custom record searches which can then be passed to the record provider. An example of how this would be done for the credits.aleo program is shown below.
     *
     * ```swift
     * struct CustomRecordSearch: RecordSearchParams {
     *     var startHeight: Int?
     *     var endHeight: Int?
     *     var amount: Int
     *     var program: String
     *     var recordName: String
     * }
     *
     * let params = CustomRecordSearch(startHeight: 0, endHeight: 100, amount: 5000, program: "credits.aleo", recordName: "credits")
     *
     * let record = try await recordProvider.findRecord(unspent: true, nonces: [], searchParameters: params)
     * ```
     */
    func findRecord(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext

    /**
     * Find multiple records from arbitrary programs
     *
     * - Parameters:
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so that they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: The record if found, otherwise an error
     *
     * The `RecordSearchParams` interface can be used to create parameters for custom record searches which can then be passed to the record provider. An example of how this would be done for the credits.aleo program is shown below.
     *
     * ```swift
     * struct CustomRecordSearch: RecordSearchParams {
     *     var startHeight: Int?
     *     var endHeight: Int?
     *     var amount: Int
     *     var maxRecords: Int
     *     var programName: String
     *     var recordName: String
     * }
     *
     * let params = CustomRecordSearch(startHeight: 0, endHeight: 100, amount: 5000, maxRecords: 2, programName: "credits.aleo", recordName: "credits")
     * let records = try await recordProvider.findRecord(unspent: true, nonces: [], searchParameters: params)
     * ```
     */
    func findRecords(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> [RecordPlaintext]
}

/**
 * A record provider implementation that uses the official Aleo API to find records for usage in program execution and
 * deployment, wallet functionality, and other use cases.
 */
public class NetworkRecordProvider: RecordProvider {
    public var account: Account
    var networkClient: NetworkClient
    
    public init(account: Account, cloudClient: NetworkClient) {
        self.account = account;
        self.networkClient = cloudClient;
    }

    /**
     * Set the account used to search for records
     *
     * - Parameter: {Account} account The account to use for searching for records
     */
    public func set(account: Account) {
        self.account = account;
    }

    /**
     * Find a list of credit records with a given number of microcredits by via the official Aleo API
     *
     * - Parameters:
     *      - microcredits: The number of microcredits to search for
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so that they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: The record if found, otherwise an error
     *
     *
     * Create a new `NetworkRecordProvider`
     * ```javascript
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const keyProvider = new AleoKeyProvider();
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     * ```
     *
     * The record provider can be used to find records with a given number of microcredits
     * ```javascript
     * const record = await recordProvider.findCreditsRecord(5000, true, []);
     * ```
     *
     * When a record is found but not yet used, it's nonce should be added to the nonces parameter so that it is not found again if a subsequent search is performed
     * ```javascript
     * const records = await recordProvider.findCreditsRecords(5000, true, [record.nonce()]);
     * ```
     *
     * When the program manager is initialized with the record provider it will be used to find automatically find fee records and amount records for value transfers so that they do not need to be specified manually
     * ```javascript
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     * ```
     * */
    public func findCreditsRecords(microcredits: [Int], unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws ->[RecordPlaintext] {
        var startHeight = 0;
        var endHeight = 0;

        if let searchParameters {
            if let sH = searchParameters.startHeight,
               let _ = searchParameters.endHeight {
                startHeight = sH
            }

            if let eH = searchParameters.endHeight {
                endHeight = eH;
            }
        }

        // If the end height is not specified, use the current block height
        if endHeight == 0 {
            let end = try await networkClient.getLatestHeight();
            
            endHeight = end;
        }

        // If the start height is greater than the end height, throw an error
        if startHeight >= endHeight {
            throw RecordProviderError.startHeightMustBeLessThanEnd
        }

        return try await networkClient.findUnspentRecords(startHeight: startHeight, endHeight: endHeight, privateKey: account.privateKey, amounts: microcredits, maxMicrocredits: nil, nonces: nonces ?? [])
    }

    /**
     * Find a credit record with a given number of microcredits by via the official Aleo API
     *
     * - Parameters:
     *      - microcredit:s The number of microcredits to search for
     *      - unspent: Whether or not the record is unspent
     *      - nonces: Nonces of records already found so that they are not found again
     *      - searchParameters: Additional parameters to search for
     * - Returns: The record if found, otherwise an error
     *
     *
     * Create a new `NetworkRecordProvider`
     * ```javascript
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const keyProvider = new AleoKeyProvider();
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     * ```
     *
     * The record provider can be used to find records with a given number of microcredits
     * ```javascript
     * const record = await recordProvider.findCreditsRecord(5000, true, []);
     * ```
     *
     * When a record is found but not yet used, it's nonce should be added to the nonces parameter so that it is not found again if a subsequent search is performed
     * ```javascript
     * const records = await recordProvider.findCreditsRecords(5000, true, [record.nonce()]);
     * ```
     *
     * When the program manager is initialized with the record provider it will be used to find automatically find fee records and amount records for value transfers so that they do not need to be specified manually
     * ```javascript
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     * ```
     */
    public func findCreditsRecord(microcredits: Int, unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext {
        
        let records = try await self.findCreditsRecords(microcredits: [microcredits], unspent: unspent, nonces: nonces, searchParameters: searchParameters);
        
        if let first = records.first {
            return first
        }
        
        print("Record not found with error:", records)
        
        throw RecordProviderError.recordNotFound
    }

    /**
     * Find an arbitrary record. WARNING: This function is not implemented yet and will throw an error.
     */
    public func findRecord(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext {
        throw RecordProviderError.methodNotImplemented
    }

    /**
     * Find multiple arbitrary records. WARNING: This function is not implemented yet and will throw an error.
     */
    public func findRecords(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> [RecordPlaintext] {
        throw RecordProviderError.methodNotImplemented
    }

}


enum RecordProviderError: Error, LocalizedError {
    case methodNotImplemented, recordNotFound, startHeightMustBeLessThanEnd
    
    var errorDescription: String? {
        switch self {
        case .methodNotImplemented:
            "Method not implemented."
        case .recordNotFound:
            "Record not found"
        case .startHeightMustBeLessThanEnd:
            "Start height must be less than end height"
        }
    }
}
