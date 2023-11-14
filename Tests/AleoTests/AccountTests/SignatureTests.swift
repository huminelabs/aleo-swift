//
//  SignatureTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import XCTest

@testable import Aleo

final class SignatureTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }

    func testSignAndVerify() throws {
        // Sample a new private key and message.
        let privateKey = PrivateKey()
        let message = (0..<32).map { _ in UInt8.random(in: 0...255) }
        
        // Sign the message.
        let signature = Signature(privateKey: privateKey, message: message)
        
        // Check the signature is valid.
        XCTAssert(signature.verify(address: privateKey.address, message: message))
        
        // Sample a different message.
        let badMessage = (0..<32).map { _ in UInt8.random(in: 0...255) }
        // Check the signature is invalid.
        XCTAssertFalse(signature.verify(address: privateKey.address, message: badMessage))
    }

}
