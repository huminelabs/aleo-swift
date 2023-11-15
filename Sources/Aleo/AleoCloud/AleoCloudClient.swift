//
//  AleoCloudClient.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation
import SwiftUI
import Observation

import SwiftCloud

@Observable
public class AleoCloudClient: CloudService<AleoCloudHost, AleoCloudPath> {
    
    var account: Account?
    
    public func set(account: Account) -> Self {
        let s = self
        s.account = account
        return s
    }
    
    public func set(account: Account) {
        self.account = account
    }
    
    public func findUnspentRecords(startHeight: Int, endHeight: Int? = nil, privateKey: PrivateKey? = nil, amounts: [Int]? = nil, maxMicrocredits: Int? = nil, nonces: [String] = []) async throws -> [RecordPlaintext] {
        guard startHeight > 0 else {
            throw AleoCloudError.startHeightLessThanZero
        }
        
        let resolvedPrivateKey: PrivateKey
        if let privateKey = privateKey {
            resolvedPrivateKey = privateKey
        } else if let account = account {
            resolvedPrivateKey = account.privateKey
        } else {
            throw AleoCloudError.privateKeyNotFound
        }
        
        let viewKey = resolvedPrivateKey.viewKey
        
        let latestHeight = try await getLatestHeight()
        
        let resolvedEndHeight: Int
        
        if let endHeight = endHeight, endHeight <= latestHeight {
            resolvedEndHeight = endHeight
        } else {
            resolvedEndHeight = latestHeight
        }
        
        guard startHeight < resolvedEndHeight else {
            throw AleoCloudError.heightError
        }
        
        var end = resolvedEndHeight
        var records = [RecordPlaintext]()
        var totalRecordValue = 0
        var failures = 0
        var start: Int
        
        while (end > startHeight) {
            start = end - 50
            
            if start < startHeight {
                start = startHeight
            }
            
            let blocks = try await getBlocks(in: start...end)
            
            end = start
            
            for block in blocks {
                guard let transactions = block.transactions else {
                    continue
                }
                for confirmedTransactions in transactions {
                    let transaction = confirmedTransactions.transaction
                    
                    guard let transitions = transaction.execution.transitions else {
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
                            
                            guard let record = RecordCiphertext(output.value),
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
                                    records.append(recordPlaintext)
                                    
                                    if let maxMicrocredits = maxMicrocredits {
                                        totalRecordValue += recordPlaintext.microcredits
                                        if totalRecordValue >= maxMicrocredits {
                                            return records
                                        }
                                    }
                                    
                                    continue
                                }
                                
                                var amountsFound = 0
                                
                                if recordPlaintext.microcredits > amounts[amountsFound] {
                                    amountsFound += 1
                                    records.append(recordPlaintext)
                                    
                                    if let maxMicrocredits = maxMicrocredits {
                                        totalRecordValue += recordPlaintext.microcredits
                                        
                                        if totalRecordValue >= maxMicrocredits {
                                            return records
                                        }
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
        }
        
        return records
    }
    
    public func getBlock(height: Int) async throws -> Block {
        let (data, _) = try await sendRequest(at: .block, using: .get)
        
        return try JSONDecoder().decode(Block.self, from: data)
    }
    
    public func getBlocks(in range: ClosedRange<Int>) async throws -> [Block] {
        let params = [
            "start": range.lowerBound,
            "end": range.upperBound
        ]
        
        let payloadData = try JSONEncoder().encode(params)
        
        let (data, _) = try await sendRequest(at: .blocks, using: .get, body: payloadData)
        
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
    
    public func getProgram(programID: String) async throws -> String {
        let (data, _) = try await sendRequest(at: .program(programID), using: .get)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
    
    public func getStateRoot() async throws -> String {
        let (data, _) = try await sendRequest(at: .stateRoot, using: .get)
        
        return try JSONDecoder().decode(String.self, from: data)
    }
    
    public func getTransaction(id: String) async throws -> CloudTransaction {
        let (data, _) = try await sendRequest(at: .transaction(id), using: .get)
        
        return try JSONDecoder().decode(CloudTransaction.self, from: data)
    }
    
    public func getTransactions(height: Int) async throws -> [CloudTransaction] {
        let (data, _) = try await sendRequest(at: .blockTransactions(height), using: .get)
        
        return try JSONDecoder().decode([CloudTransaction].self, from: data)
    }
    
    public func getTransactionsInMemoryPool() async throws -> [CloudTransaction] {
        let (data, _) = try await sendRequest(at: .memoryPoolTransactions, using: .get)
        
        return try JSONDecoder().decode([CloudTransaction].self, from: data)
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
