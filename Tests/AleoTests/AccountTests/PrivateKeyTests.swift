//
//  PrivateKeyTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/11/23.
//

import XCTest

@testable import Aleo

final class PrivateKeyTests: XCTestCase {
    
    var aleoPrivateKey = "APrivateKey1zkp3dQx4WASWYQVWKkq14v3RoQDfY2kbLssUj7iifi1VUQ6"
    var aleoViewKey = "AViewKey1cxguxtKkjYnT9XDza9yTvVMxt6Ckb1Pv4ck1hppMzmCB"
    var aleoAddress = "aleo184vuwr5u7u0ha5f5k44067dd2uaqewxx6pe5ltha5pv99wvhfqxqv339h4"

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testSanityCheck() throws {
        let privateKey = PrivateKey(aleoPrivateKey)
        
        print("""
        Private Key: \(aleoPrivateKey) == \(String(describing: privateKey))
        """)
        
        XCTAssertEqual(aleoPrivateKey, privateKey?.toString())
        
        print("""
        View Key: \(aleoViewKey) == \(String(describing: privateKey?.viewKey))
        """)
        
        XCTAssertEqual(aleoViewKey, privateKey?.viewKey.toString())
        
        print("""
        Address: \(aleoAddress) == \(String(describing: privateKey?.address))
        """)
        
        XCTAssertEqual(aleoAddress, privateKey?.address.toString())
    }
    
    func testNew() throws {
        // Generate a new private key.
        let expected = PrivateKey()
        
        // Check the private_key derived from string.
        XCTAssertEqual(expected, PrivateKey("\(expected)"))
    }

    func testFromSeedUnchecked() throws {
        // Sample a random seed using native Swift generator.
        let seed = (0..<32).map { _ in UInt8.random(in: 0...255) }
        
        // Ensure the private key is deterministically recoverable.
        let expected = PrivateKey(seed: seed)
        
        XCTAssertEqual(expected, PrivateKey(seed: seed))
    }
    
    func testToAddress() throws {
        // Sample a new private key.
        let privateKey = PrivateKey()
        
        let expected = privateKey.address
        
        // Check the private key derived from the view key.
        let viewKey = privateKey.viewKey
        
        XCTAssertEqual(expected, Address(viewKey: viewKey))
    }
    
    func testSignature() throws {
        // Sample a new private key and message.
        let privateKey = PrivateKey()
        let message = (0..<32).map { _ in UInt8.random(in: 0...255) }
        
        // Sign the message.
        let signature = privateKey.sign(message: message)
        
        // Check the signature is valid.
        XCTAssert(signature.verify(address: privateKey.address, message: message))
    }

}
