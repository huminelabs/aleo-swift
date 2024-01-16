//
//  ProvingKeyTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/22/23.
//

import XCTest

@testable import Aleo

final class ProvingKeyTests: XCTestCase {
    
    var provingKeyData: Data!
    var provingKeyBase: ProvingKey!
    
    override func setUp() async throws {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://testnet3.parameters.aleo.org/join.prover.30895cc")!)
        
        self.provingKeyData = data
        self.provingKeyBase = ProvingKey(data)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProvingKeyRoundtrip() async throws {
        let provingKey = ProvingKey(provingKeyData)
        let data = provingKey!.toBytes()!
        
        for (a, b) in zip(provingKeyData, data) {
            XCTAssertEqual(a, b)
        }
    }
    
    func testFromString() async throws {
        let options = XCTMeasureOptions()
        options.iterationCount = 1
        
//        self.measure(options: options) {
            let string = "\(provingKeyBase!)"
            let fromString = ProvingKey(string)
            
            XCTAssertEqual(string, fromString?.toString())
//        }
    }
}
