//
//  NetworkClient+Models.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation

extension NetworkClient {
    public struct Block: Codable {
        enum CodingKeys: String, CodingKey {
            case blockHash = "block_hash"
            case previousHash = "previous_hash"
            case header
            case transactions
        }
        public var blockHash: String
        public var previousHash: String
        public var header: Header
        public var transactions: [ConfirmedTransaction]?
    }
    
    public struct Header: Codable {
        enum CodingKeys: String, CodingKey {
            case previousStateRoot = "previous_state_root"
            case transactionsRoot = "transactions_root"
            case metadata
        }
        public var previousStateRoot: String
        public var transactionsRoot: String
        public var metadata: Metadata
    }
    
    public struct Metadata: Codable {
        enum CodingKeys: String, CodingKey {
            case network, round, height, coinbaseTarget = "coinbase_target", proofTarget = "proof_target", timestamp
        }
        public var network: Int
        public var round: Int
        public var height: Int
        public var coinbaseTarget: Int
        public var proofTarget: Int
        public var timestamp: Int
    }
    
    public struct ConfirmedTransaction: Codable {
        public var type: String
        public var status: String
        public var index: Int
        public var transaction: ExecutionTransaction
    }
    
    public struct ExecutionTransaction: Codable {
        public var type: String
        public var id: String
        public var execution: Execution?
    }
    
    public struct Execution: Codable {
        enum CodingKeys: String, CodingKey {
            case globalStateRoot = "global_state_root", proof, transitions
        }
        public var globalStateRoot: String
        public var proof: String
        public var transitions: [Transition]?
    }
    
    public struct Transition: Codable {
        public var id: String
        public var program: String
        public var function: String
        public var inputs: [Input]?
        public var outputs: [Output]?
        public var tpk: String?
        public var tcm: String?
    }
    
    public struct Input: Codable {
        public var type: String
        public var id: String
        public var tag: String?
        public var origin: Origin?
        public var value: String?
    }
    
    public struct Origin: Codable {
        public var commitment: String?
    }
    
    public struct Output: Codable {
        public var type: String
        public var id: String
        public var checksum: String?
        public var value: String?
    }
}
