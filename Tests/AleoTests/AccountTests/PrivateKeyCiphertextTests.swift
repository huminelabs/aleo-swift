//
//  PrivateKeyCiphertextTests.swift
//
//
//  Created by Nafeh Shoaib on 11/2/23.
//

import XCTest

@testable import Aleo

final class PrivateKeyCiphertextTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPrivateKeyCiphertexttoandFromString() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")!
        let privateKeyCiphertext2 = PrivateKeyCiphertext("\(privateKeyCiphertext)")
        
        // Assert the round trip to and from string journey results in the same key
        XCTAssertEqual(privateKeyCiphertext, privateKeyCiphertext2)
    }
    
    
    func testPrivateKeyFromStringDecryptionEdgeCases() throws {
        let privateKey =
        PrivateKey("APrivateKey1zkpAYS46Dq4rnt9wdohyWMwdmjmTeMJKPZdp5AhvjXZDsVG")!
        let ciphertext = "ciphertext1qvqg7rgvam3xdcu55pwu6sl8rxwefxaj5gwthk0yzln6jv5fastzup0qn0qftqlqq7jcckyx03fzv9kke0z9puwd7cl7jzyhxfy2f2juplz39dkqs6p24urhxymhv364qm3z8mvyklv5gr52n4fxr2z59jgqytyddj8"
        let privateKeyCiphertext = PrivateKeyCiphertext(ciphertext)
        let decryptedPrivateKey = privateKeyCiphertext?.decryptToPrivateKey(using: "mypassword")
        
        // Assert that the private key is the same as the original for a valid ciphertext and secret
        XCTAssertEqual(privateKey, decryptedPrivateKey)
        // Assert the incorrect secret fails
        XCTAssertNil(privateKeyCiphertext?.decryptToPrivateKey(using: "badpassword"))
        // Ensure invalid ciphertexts fail
        let badCiphertext = "ciphertext1qvqg7rgvam3xdcu55pwu6sl8rxwefxaj5gwthk0yzln6jv5fastzup0qn0qftqlqq7jcckyx03fzv9kke0z9puwd7cl7jzyhxfy2f2juplz39dkqs6p24urhxymhv364qm3z8mvyklv5er52n4fxr2z59jgqytyddj8"
        XCTAssertNil(PrivateKeyCiphertext(badCiphertext))
    }
    
    
    func testPrivateKeyCiphertextEncryptAndDecrypt() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        let recoveredPrivateKey = privateKeyCiphertext?.decryptToPrivateKey(using: "mypassword")
        
        XCTAssertNotNil(privateKeyCiphertext)
        XCTAssertNotNil(recoveredPrivateKey)
        XCTAssertEqual(privateKey, recoveredPrivateKey)
    }
    
    
    func testPrivateKeyCiphertextDoesntDecryptWithWrongPassword() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        let recoveredPrivateKey = privateKeyCiphertext?.decryptToPrivateKey(using: "wrongpassword")
        XCTAssertNil(recoveredPrivateKey)
    }
    
    
    func testPrivateKeyCiphertextDoesntProduceSameCiphertextOnDifferentRuns() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        let privateKeyCiphertext2 = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        XCTAssertNotEqual(privateKeyCiphertext, privateKeyCiphertext2)
        
        // Assert that we can decrypt both ciphertexts with the same secret despite being different
        let recoveredKey1 = privateKeyCiphertext?.decryptToPrivateKey(using: "mypassword")
        let recoveredKey2 = privateKeyCiphertext2?.decryptToPrivateKey(using: "mypassword")
        XCTAssertEqual(recoveredKey1, recoveredKey2)
    }
    
    
    func testPrivateKeyCiphertextEncryptedWithDifferentPasswordsMatch() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        let privateKeyCiphertext2 = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword2")
        XCTAssertNotEqual(privateKeyCiphertext, privateKeyCiphertext2)
        
        // Assert that we can decrypt both ciphertexts with the same secret despite being different
        let recoveredKey1 = privateKeyCiphertext?.decryptToPrivateKey(using: "mypassword")
        let recoveredKey2 = privateKeyCiphertext2?.decryptToPrivateKey(using: "mypassword2")
        XCTAssertEqual(recoveredKey1, recoveredKey2)
    }
    
    
    func testPrivateKeyCiphertextDifferentPrivateKeysEncryptedWithSamePasswordDontMatch() throws {
        let privateKey = PrivateKey()
        let privateKey2 = PrivateKey()
        let privateKeyCiphertext = PrivateKeyCiphertext(privateKey: privateKey, secret: "mypassword")
        let privateKeyCiphertext2 = PrivateKeyCiphertext(privateKey: privateKey2, secret: "mypassword")
        XCTAssertNotEqual(privateKeyCiphertext, privateKeyCiphertext2)
        
        // Assert that private key plaintexts dont match
        let recoveredKey1 = privateKeyCiphertext?.decryptToPrivateKey(using: "mypassword")
        let recoveredKey2 = privateKeyCiphertext2?.decryptToPrivateKey(using: "mypassword")
        XCTAssertNotEqual(recoveredKey1, recoveredKey2)
    }
    
    
    func testPrivateKeyCiphertextDecryptsProperlyWhenFormedWithSecret() throws {
        let privateKeyCiphertext1 = PrivateKey.newEncrypted(secret: "mypassword")!
        let privateKeyCiphertext2 = PrivateKey.newEncrypted(secret: "mypassword")!
        
        // Assert that ciphertexts are different
        XCTAssertNotEqual(privateKeyCiphertext1, privateKeyCiphertext2)
        
        // Check both possible decryption methods recover the first key
        let recoveredPrivateKey11 = privateKeyCiphertext1.decryptToPrivateKey(using: "mypassword")
        let recoveredPrivateKey12 =
        PrivateKey(ciphertext: privateKeyCiphertext1, secret: "mypassword")
        XCTAssertEqual(recoveredPrivateKey11, recoveredPrivateKey12)
        
        // Check both possible decryption methods recover the second key
        let recoveredPrivateKey21 = privateKeyCiphertext2.decryptToPrivateKey(using: "mypassword")
        let recoveredPrivateKey22 =
        PrivateKey(ciphertext: privateKeyCiphertext2, secret: "mypassword")
        XCTAssertEqual(recoveredPrivateKey21, recoveredPrivateKey22)
        
        // Check that the two keys recovered are different
        XCTAssertNotEqual(recoveredPrivateKey11, recoveredPrivateKey21)
        XCTAssertNotEqual(recoveredPrivateKey12, recoveredPrivateKey22)
        XCTAssertNotEqual(recoveredPrivateKey11, recoveredPrivateKey21)
        XCTAssertNotEqual(recoveredPrivateKey12, recoveredPrivateKey22)
    }
    
    
    func testPrivateKeyEncryptionFunctions() throws {
        let privateKey = PrivateKey()
        let privateKeyCiphertext = privateKey.toCiphertext(secret: "mypassword")!
        let recoveredPrivateKey1 =
        PrivateKey(ciphertext: privateKeyCiphertext, secret: "mypassword")
        let recoveredPrivateKey2 = privateKeyCiphertext.decryptToPrivateKey(using: "mypassword")
        
        // Check both possible decryption methods recover the key
        XCTAssertEqual(privateKey, recoveredPrivateKey2)
        XCTAssertEqual(privateKey, recoveredPrivateKey1)
        // Check transitivity holds explicitly
        XCTAssertEqual(recoveredPrivateKey1, recoveredPrivateKey2)
        
        // Ensure decryption fails with incorrect secret
        let badSecretAttempt = PrivateKey(ciphertext: privateKeyCiphertext, secret: "badpassword")
        XCTAssertNil(badSecretAttempt)
    }
    
}
