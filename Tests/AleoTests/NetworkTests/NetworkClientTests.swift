//
//  NetworkClientTests.swift
//  
//
//  Created by Nafeh Shoaib on 3/22/24.
//

import XCTest

@testable import Aleo

final class NetworkClientTests: XCTestCase {
    
    var client: NetworkClient!
    
    var recordsProvider: NetworkRecordProvider!

    override func setUp() async throws {
        client = NetworkClient(serverURL: .testnet3)
        recordsProvider = NetworkRecordProvider(account: Account(), client: client)
    }

    override func tearDown() async throws {
        
    }

    func testSetAccount() async throws {
        let account = Account()
        
        client.set(account: account)
        
        XCTAssertEqual(client.account, account)
    }
    
    func testGetBlock() async throws {
        let block = try await client.getBlock(height: 1)
        
        XCTAssertEqual(block.blockHash, "ab1hap8jlxaz66yt887gxlgxptkm2y0dy72x529mq6pg3ysy9tzwyqsphva9c")
    }
    
    func testGetBlocksInRange() async throws {
        let blocks = try await client.getBlocks(in: 1...3)
        
        XCTAssertEqual(blocks.count, 2)
        XCTAssertEqual(blocks.first?.blockHash, "ab1hap8jlxaz66yt887gxlgxptkm2y0dy72x529mq6pg3ysy9tzwyqsphva9c")
        XCTAssertEqual(blocks.last?.blockHash, "ab18dzmjgqgk5z6x4gggezca7aenqts7289chvhus4a7ydrcj4apvrqq5j5h8")
    }
    
    func testGetBlocksInRange2() async throws {
        let blocks = try await client.getBlocks(in: 1807649...1807650)
        
        XCTAssertEqual(blocks.count, 2)
        XCTAssertEqual(blocks.first?.blockHash, "ab1hap8jlxaz66yt887gxlgxptkm2y0dy72x529mq6pg3ysy9tzwyqsphva9c")
        XCTAssertEqual(blocks.last?.blockHash, "ab18dzmjgqgk5z6x4gggezca7aenqts7289chvhus4a7ydrcj4apvrqq5j5h8")
    }
    
    func testGetProgram() async throws {
        let program = try await client.getProgram(programID: "credits.aleo")
        
        XCTAssertNotNil(program)
    }
    
    func testFindUnspentRecords() async throws {
        let records = try await client.findUnspentRecords(startHeight: 0, endHeight: 204, privateKey: PrivateKey("APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH"))
        
        XCTAssert(records.isEmpty)
    }
    
    func testFindCreditRecords() async throws {
        let params = BlockHeightSearch(startHeight: 0, endHeight: 100)
        
        let records = try await recordsProvider.findCreditsRecords(microcredits: [100.0, 200.0], unspent: true, nonces: [], searchParameters: params)
        
        XCTAssert(records.isEmpty)
    }
}
