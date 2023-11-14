//
//  AddressTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/2/23.
//

import XCTest

@testable import Aleo

final class AddressTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testSanity() throws {
        let privateKey = PrivateKey()
        let expected = Address(privateKey: privateKey)
        
        let viewKey = privateKey.viewKey
        let newAddress = Address(viewKey: viewKey)
        
        print("""
            Aleo address tests:
                private key: \(privateKey)
                viewKey: \(viewKey)
                expected address: \(expected)
                address: \(newAddress)
            """)
        
        XCTAssertEqual(newAddress, expected)
    }
}
