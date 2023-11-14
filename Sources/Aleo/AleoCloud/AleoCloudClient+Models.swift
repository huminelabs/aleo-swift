//
//  AleoNetworkBlock.swift
//
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import Foundation

extension AleoCloudClient {
    struct Block: Codable {
        enum CodingKeys: String, CodingKey {
            case blockHash = "block_hash"
            case previousHash = "previous_hash"
            case header
            case transactions
            case signature
        }
        var blockHash: String
        var previousHash: String
        var header: Header
        var transactions: [ConfirmedTransaction]?
        var signature: String
    }
    
    struct Header: Codable {
        enum CodingKeys: String, CodingKey {
            case previousStateRoot = "previous_state_root"
            case transactionsRoot = "transactions_root"
            case metadata
        }
        var previousStateRoot: String
        var transactionsRoot: String
        var metadata: Metadata
    }
    
    struct Metadata: Codable {
        enum CodingKeys: String, CodingKey {
            case network, round, height, coinbaseTarget = "coinbase_target", proofTarget = "proof_target", timestamp
        }
        var network: Int
        var round: Int
        var height: Int
        var coinbaseTarget: Int
        var proofTarget: Int
        var timestamp: Int
    }
    
    struct ConfirmedTransaction: Codable {
        var type: String
        var id: String
        var transaction: Transaction
    }
    
    struct Transaction: Codable {
        var type: String
        var id: String
        var execution: Execution
    }
    
    struct Execution: Codable {
        var edition: Int
        var transition: [Transition]?
    }
    
    struct Transition: Codable {
        var id: String
        var program: String
        var function: String
        var inputs: [Input]?
        var outputs: [Output]?
        var proof: String
        var tpk: String
        var tcm: String
        var fee: Int
    }
    
    struct Input: Codable {
        var type: String
        var id: String
        var tag: String?
        var origin: Origin?
        var value: String?
    }
    
    struct Origin: Codable {
        var commitment: String
    }
    
    struct Output: Codable {
        var type: String;
        var id: String;
        var checksum: String;
        var value: String;
    }
}
