//
//  NetworkClient.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation
import SwiftUI
import Observation
import os

import SwiftCloud

/**
 * Client library that encapsulates REST calls to publicly exposed endpoints of Aleo nodes. The methods provided in this
 * allow users to query public information from the Aleo blockchain and submit transactions to the network.
 *
 * @param {string} host
 * ```swift
 * // Connection to a local node
 * let localNetworkClient = NetworkClient("http://localhost:3030")
 *
 * // Connection to a public beacon node
 * let publicNetworkClient = NetworkClient("https://api.explorer.aleo.org/v1")
 * ```
 */
@Observable
public class NetworkClient: BasicCloudService<NetworkHost, NetworkPath> {
    
    var account: Account?
    
    public convenience init(_ hostString: String) {
        self.init(serverURL: NetworkHost.custom(hostString))
    }
    
    public func withSet(account: Account) -> Self {
        let s = self
        s.account = account
        return s
    }
    
    public func set(account: Account) {
        self.account = account
    }
    
    public func findUnspentRecords(startHeight: Int, endHeight: Int? = nil, privateKey: PrivateKey? = nil, amounts: [Float]? = nil, maxMicrocredits: Float? = nil, nonces: [String] = []) async throws -> [RecordPlaintext] {
        // Ensure start height is not negative
        guard startHeight >= 0 else {
            throw NetworkError.startHeightLessThanZero
        }
        
        // Ensure a private key is present to find owned records
        let resolvedPrivateKey: PrivateKey
        if let privateKey = privateKey {
            resolvedPrivateKey = privateKey
        } else if let account = account {
            resolvedPrivateKey = account.privateKey
        } else {
            throw NetworkError.privateKeyNotFound
        }
        
        // Initialize search parameters
        let viewKey = resolvedPrivateKey.viewKey
        
        // Get the latest height to ensure the range being searched is valid
        let latestHeight = try await getLatestHeight()
        let resolvedEndHeight: Int
        
        // If no end height is specified or is greater than the latest height, set the end height to the latest height
        if let endHeight = endHeight, endHeight <= latestHeight {
            resolvedEndHeight = endHeight
        } else {
            resolvedEndHeight = latestHeight
        }
        
        // If the starting is greater than the ending height, return an error
        guard startHeight <= resolvedEndHeight else {
            throw NetworkError.heightError
        }
        
        var end = resolvedEndHeight
        var records = [RecordPlaintext]()
        var totalRecordValue: Float = 0.0
        var failures = 0
        var start: Int
        
        let addToTotalRecordValueAndCheck = { (recordPlaintext: RecordPlaintext, r: [RecordPlaintext]) -> Bool in
            // If the user specified a maximum number of microcredits, check if the search has found enough
            if let maxMicrocredits = maxMicrocredits {
                totalRecordValue += recordPlaintext.microcredits
                // Exit if the search has found the amount specified
                if totalRecordValue >= maxMicrocredits {
                    return true
                }
            }
            
            return false
        }
        
        // Iterate through blocks in reverse order in chunks of 50
        while (end > startHeight) {
            start = end - 50
            
            if start < startHeight {
                start = startHeight
            }
            
            do {
                // Get 50 blocks (or the difference between the start and end if less than 50)
                let blocks = try await getBlocks(in: start...end)
                
                end = start
                
                // Iterate through blocks to find unspent records
                for block in blocks {
                    guard let transactions = block.transactions else {
                        continue
                    }
                    for confirmedTransaction in transactions {
                        guard confirmedTransaction.type == "execute" else {
                            continue
                        }
                        
                        let transaction = confirmedTransaction.transaction
                        
                        guard let transitions = transaction.execution?.transitions else {
                            continue
                        }
                        
                        for transition in transitions {
                            guard transition.program == "credits.aleo" else {
                                continue
                            }
                            
                            guard let outputs = transition.outputs else {
                                continue
                            }
                            
                            for output in outputs {
                                guard output.type == "record" else {
                                    continue
                                }
                                
                                guard let outputValue = output.value,
                                      let record = RecordCiphertext(outputValue),
                                      record.isOwner(viewKey: viewKey),
                                      let recordPlaintext = record.decrypt(viewKey: viewKey),
                                      !nonces.contains(recordPlaintext.nonce) else {
                                    continue
                                }
                                
                                guard let serialNumber = recordPlaintext.serialNumber(privateKey: resolvedPrivateKey, programID: "credits.aleo", recordName: "credits") else {
                                    continue
                                }
                                
                                do {
                                    let _ = try await getTransaction(id: serialNumber)
                                } catch {
                                    guard let amounts = amounts,
                                          !amounts.isEmpty else {
                                        // If it's not found, add it to the list of unspent records
                                        records.append(recordPlaintext)
                                        
                                        if addToTotalRecordValueAndCheck(recordPlaintext, records) {
                                            return records
                                        }
                                        
                                        continue
                                    }
                                    
                                    // If the user specified a list of amounts, check if the search has found them
                                    var amountsFound = 0
                                    
                                    if recordPlaintext.microcredits > amounts[amountsFound] {
                                        amountsFound += 1
                                        records.append(recordPlaintext)
                                        
                                        if addToTotalRecordValueAndCheck(recordPlaintext, records) {
                                            return records
                                        }
                                        
                                        if records.count >= amounts.count {
                                            return records
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                os_log("Error fetching blocks in range: \(start) - \(end) with error: \(error)")
                failures += 1
                
                if failures > 10 {
                    os_log("Failed to fetch records with 10 failures. Returning records so far")
                    
                    return records
                }
            }
        }
        
        return records
    }
    
    public func getBlock(height: Int) async throws -> Block {
        let (data, _) = try await sendRequest(at: .block(height), using: .get)
        
        return try JSONDecoder().decode(Block.self, from: data)
    }
    
    public func getBlocks(in range: ClosedRange<Int>) async throws -> [Block] {
        let params = [
            "start": "\(range.lowerBound)",
            "end": "\(range.upperBound)"
        ]
        
        let (data, _) = try await sendRequest(at: .blocks, using: .get, queryParams: params)
        
        return try JSONDecoder().decode([Block].self, from: data)
    }
    
    public func getLatestBlock() async throws -> Block {
        let (data, _) = try await sendRequest(at: .latestBlock, using: .get)
        
        return try JSONDecoder().decode(Block.self, from: data)
    }
    
    public func getLatestHeight() async throws -> Int {
        let (data, _) = try await sendRequest(at: .latestHeight, using: .get)
        
        return try JSONDecoder().decode(Int.self, from: data)
    }
    
    public func getProgram(programID: String) async throws -> String? {
        let (data, _) = try await sendRequest(at: .program(programID), using: .get)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
    
    public func getStateRoot() async throws -> String {
        let (data, _) = try await sendRequest(at: .stateRoot, using: .get)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
    
    public func getTransaction(id: String) async throws -> ExecutionTransaction {
        let (data, _) = try await sendRequest(at: .transaction(id), using: .get)
        
        return try JSONDecoder().decode(ExecutionTransaction.self, from: data)
    }
    
    public func getTransactions(height: Int) async throws -> [ExecutionTransaction] {
        let (data, _) = try await sendRequest(at: .blockTransactions(height), using: .get)
        
        return try JSONDecoder().decode([ExecutionTransaction].self, from: data)
    }
    
    public func getTransactionsInMemoryPool() async throws -> [ExecutionTransaction] {
        let (data, _) = try await sendRequest(at: .memoryPoolTransactions, using: .get)
        
        return try JSONDecoder().decode([ExecutionTransaction].self, from: data)
    }
    
    public func getTransitionID(usingInputOrOutID id: String) async throws -> String {
        let (data, _) = try await sendRequest(at: .latestHeight, using: .get)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
    
    public func submit(transaction: Transaction) async throws -> String {
        let transactionString = transaction.toString()
        
        let payloadData = try JSONEncoder().encode(transactionString)
        
        let (data, _) = try await sendRequest(at: .transactionBroadcast, using: .post, body: payloadData)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
}
