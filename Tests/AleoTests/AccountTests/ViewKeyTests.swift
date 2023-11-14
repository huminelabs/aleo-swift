//
//  ViewKeyTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/2/23.
//

import XCTest

@testable import Aleo

final class ViewKeyTests: XCTestCase {
    
    let expectedPlaintext = """
    {
      owner: aleo1j7qxyunfldj2lp8hsvy7mw5k8zaqgjfyr72x2gh3x4ewgae8v5gscf5jh3.private,
      microcredits: 1500000000000000u64.private,
      _nonce: 3077450429259593211617823051143573281856129402760267155982965992208217472983group.public
    }
    """
        let ownerCiphertext = "record1qyqsqpe2szk2wwwq56akkwx586hkndl3r8vzdwve32lm7elvphh37rsyqyxx66trwfhkxun9v35hguerqqpqzqrtjzeu6vah9x2me2exkgege824sd8x2379scspmrmtvczs0d93qttl7y92ga0k0rsexu409hu3vlehe3yxjhmey3frh2z5pxm5cmxsv4un97q"
        let ownerViewKey = "AViewKey1ccEt8A2Ryva5rxnKcAbn7wgTaTsb79tzkKHFpeKsm9NX"
        let nonOwnerViewKey = "AViewKey1e2WyreaH5H4RBcioLL2GnxvHk5Ud46EtwycnhTdXLmXp"

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testFromPrivateKey() throws {
        let givenPrivateKey = "APrivateKey1zkp4RyQ8Utj7aRcJgPQGEok8RMzWwUZzBhhgX6rhmBT8dcP"
        let givenViewKey = "AViewKey1i3fn5SECcVBtQMCVtTPSvdApoMYmg3ToJfNDfgHJAuoD"
        
        let privateKey = PrivateKey(givenPrivateKey)!
        let viewKey = ViewKey(privateKey: privateKey)
        
        XCTAssertEqual(givenViewKey, "\(viewKey)")
    }
    
    func testDecryptSuccess() throws {
        let viewKey = ViewKey(ownerViewKey)
        
        let plaintext = viewKey.decrypt(ciphertext: ownerCiphertext)
        
        XCTAssertNotNil(plaintext)
        XCTAssertEqual(expectedPlaintext, plaintext)
    }
    
    func testDecryptFails() throws {
        let ciphertext = RecordCiphertext(ownerCiphertext)
        let incorrectViewKey = ViewKey(nonOwnerViewKey)
        let plaintext = ciphertext?.decrypt(viewKey: incorrectViewKey)
        
        XCTAssertNil(plaintext)
    }
}
