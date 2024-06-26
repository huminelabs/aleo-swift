//
//  NetworkPath.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation

import SwiftCloud

public enum NetworkPath: CloudServicePath {
    case custom(String), block(Int), blocks, latestBlock, latestHeight, program(String), stateRoot, transaction(String), blockTransactions(Int), memoryPoolTransactions, transitionID(String), transactionBroadcast
    
    public var pathString: String {
        switch self {
        case .custom(let string):
            return string
        case .block(let height):
            return "block/\(height)"
        case .blocks:
            return "blocks"
        case .latestBlock:
            return "latest/block"
        case .latestHeight:
            return "latest/height"
        case .program(let programID):
            return "program/\(programID)"
        case .stateRoot:
            return "latest/stateRoot"
        case .transaction(let id):
            return "transaction/\(id)"
        case .blockTransactions(let height):
            return "block/\(height)/transactions"
        case .memoryPoolTransactions:
            return "memoryPool/transactions"
        case .transitionID(let inputOrOutputID):
            return "find/transitionID/\(inputOrOutputID)"
        case .transactionBroadcast:
            return "transaction/broadcast"
        }
    }
}
