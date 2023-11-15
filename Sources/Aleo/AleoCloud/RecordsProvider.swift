//
//  File.swift
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
     * Find a credits.aleo record with a given number of microcredits from the chosen provider
     *
     * @param {number} microcredits The number of microcredits to search for
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext | Error>} The record if found, otherwise an error
     *
     * @example
     * // A class implementing record provider can be used to find a record with a given number of microcredits
     * const record = await recordProvider.findCreditsRecord(5000, true, []);
     *
     * // When a record is found but not yet used, its nonce should be added to the nonces array so that it is not
     * // found again if a subsequent search is performed
     * const record2 = await recordProvider.findCreditsRecord(5000, true, [record.nonce()]);
     *
     * // When the program manager is initialized with the record provider it will be used to find automatically find
     * // fee records and amount records for value transfers so that they do not need to be specified manually
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     */
    func findCreditsRecord(microcredits: Int, unspent: Bool,  nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext

    /**
     * Find a list of credit.aleo records with a given number of microcredits from the chosen provider
     *
     * @param {number} microcreditAmounts A list of separate microcredit amounts to search for (e.g. [5000, 100000])
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so that they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext[] | Error>} A list of records with a value greater or equal to the amounts specified if such records exist, otherwise an error
     *
     * @example
     * // A class implementing record provider can be used to find a record with a given number of microcredits
     * const records = await recordProvider.findCreditsRecords([5000, 5000], true, []);
     *
     * // When a record is found but not yet used, it's nonce should be added to the nonces array so that it is not
     * // found again if a subsequent search is performed
     * const nonces = [];
     * records.forEach(record => { nonces.push(record.nonce()) });
     * const records2 = await recordProvider.findCreditsRecord(5000, true, nonces);
     *
     * // When the program manager is initialized with the record provider it will be used to find automatically find
     * // fee records and amount records for value transfers so that they do not need to be specified manually
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     */
    func findCreditsRecords(microcredits: [Int], unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> [RecordPlaintext]

    /**
     * Find an arbitrary record
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so that they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext | Error>} The record if found, otherwise an error
     *
     * @example
     * // The RecordSearchParams interface can be used to create parameters for custom record searches which can then
     * // be passed to the record provider. An example of how this would be done for the credits.aleo program is shown
     * // below.
     *
     * class CustomRecordSearch implements RecordSearchParams {
     *     startHeight: number;
     *     endHeight: number;
     *     amount: number;
     *     program: string;
     *     recordName: string;
     *     constructor(startHeight: number, endHeight: number, credits: number, maxRecords: number, programName: string, recordName: string) {
     *         this.startHeight = startHeight;
     *         this.endHeight = endHeight;
     *         this.amount = amount;
     *         this.program = programName;
     *         this.recordName = recordName;
     *     }
     * }
     *
     * const params = new CustomRecordSearch(0, 100, 5000, "credits.aleo", "credits");
     *
     * const record = await recordProvider.findRecord(true, [], params);
     */
    func findRecord(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> RecordPlaintext

    /**
     * Find multiple records from arbitrary programs
     *
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so that they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext | Error>} The record if found, otherwise an error
     *
     * // The RecordSearchParams interface can be used to create parameters for custom record searches which can then
     * // be passed to the record provider. An example of how this would be done for the credits.aleo program is shown
     * // below.
     *
     * class CustomRecordSearch implements RecordSearchParams {
     *     startHeight: number;
     *     endHeight: number;
     *     amount: number;
     *     maxRecords: number;
     *     programName: string;
     *     recordName: string;
     *     constructor(startHeight: number, endHeight: number, credits: number, maxRecords: number, programName: string, recordName: string) {
     *         this.startHeight = startHeight;
     *         this.endHeight = endHeight;
     *         this.amount = amount;
     *         this.maxRecords = maxRecords;
     *         this.programName = programName;
     *         this.recordName = recordName;
     *     }
     * }
     *
     * const params = new CustomRecordSearch(0, 100, 5000, 2, "credits.aleo", "credits");
     * const records = await recordProvider.findRecord(true, [], params);
     */
    func findRecords(unspent: Bool, nonces: [String]?, searchParameters: RecordSearchParams?) async throws -> [RecordPlaintext]
}

/**
 * A record provider implementation that uses the official Aleo API to find records for usage in program execution and
 * deployment, wallet functionality, and other use cases.
 */
public class NetworkRecordProvider: RecordProvider {
    public var account: Account
    var cloudClient: AleoCloudClient
    
    public init(account: Account, cloudClient: AleoCloudClient) {
        self.account = account;
        self.cloudClient = cloudClient;
    }

    /**
     * Set the account used to search for records
     *
     * @param {Account} account The account to use for searching for records
     */
    public func set(account: Account) {
        self.account = account;
    }

    /**
     * Find a list of credit records with a given number of microcredits by via the official Aleo API
     *
     * @param {number[]} microcredits The number of microcredits to search for
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so that they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext | Error>} The record if found, otherwise an error
     *
     * @example
     * // Create a new NetworkRecordProvider
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const keyProvider = new AleoKeyProvider();
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     *
     * // The record provider can be used to find records with a given number of microcredits
     * const record = await recordProvider.findCreditsRecord(5000, true, []);
     *
     * // When a record is found but not yet used, it's nonce should be added to the nonces parameter so that it is not
     * // found again if a subsequent search is performed
     * const records = await recordProvider.findCreditsRecords(5000, true, [record.nonce()]);
     *
     * // When the program manager is initialized with the record provider it will be used to find automatically find
     * // fee records and amount records for value transfers so that they do not need to be specified manually
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     *
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
            let end = try await cloudClient.getLatestHeight();
            
            endHeight = end;
        }

        // If the start height is greater than the end height, throw an error
        if startHeight >= endHeight {
            throw RecordProviderError.startHeightMustBeLessThanEnd
        }

        return try await cloudClient.findUnspentRecords(startHeight: startHeight, endHeight: endHeight, privateKey: account.privateKey, amounts: microcredits, maxMicrocredits: nil, nonces: nonces ?? [])
    }

    /**
     * Find a credit record with a given number of microcredits by via the official Aleo API
     *
     * @param {number} microcredits The number of microcredits to search for
     * @param {boolean} unspent Whether or not the record is unspent
     * @param {string[]} nonces Nonces of records already found so that they are not found again
     * @param {RecordSearchParams} searchParameters Additional parameters to search for
     * @returns {Promise<RecordPlaintext | Error>} The record if found, otherwise an error
     *
     * @example
     * // Create a new NetworkRecordProvider
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const keyProvider = new AleoKeyProvider();
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     *
     * // The record provider can be used to find records with a given number of microcredits
     * const record = await recordProvider.findCreditsRecord(5000, true, []);
     *
     * // When a record is found but not yet used, it's nonce should be added to the nonces parameter so that it is not
     * // found again if a subsequent search is performed
     * const records = await recordProvider.findCreditsRecords(5000, true, [record.nonce()]);
     *
     * // When the program manager is initialized with the record provider it will be used to find automatically find
     * // fee records and amount records for value transfers so that they do not need to be specified manually
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
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
