//
//  RecordCiphertextTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/2/23.
//

import XCTest

@testable import Aleo

final class RecordCiphertextTests: XCTestCase {
    
    let ownerPlaintext = """
    {
      owner: aleo1j7qxyunfldj2lp8hsvy7mw5k8zaqgjfyr72x2gh3x4ewgae8v5gscf5jh3.private,
      microcredits: 1500000000000000u64.private,
      _nonce: 3077450429259593211617823051143573281856129402760267155982965992208217472983group.public
    }
    """
    let ownerCiphertext = "record1qyqsqpe2szk2wwwq56akkwx586hkndl3r8vzdwve32lm7elvphh37rsyqyxx66trwfhkxun9v35hguerqqpqzqrtjzeu6vah9x2me2exkgege824sd8x2379scspmrmtvczs0d93qttl7y92ga0k0rsexu409hu3vlehe3yxjhmey3frh2z5pxm5cmxsv4un97q"
    let ownerViewKey = "AViewKey1ccEt8A2Ryva5rxnKcAbn7wgTaTsb79tzkKHFpeKsm9NX"
    let nonOwnerViewKey = "AViewKey1e2WyreaH5H4RBcioLL2GnxvHk5Ud46EtwycnhTdXLmXp"
    
    // Related material for use in future tests
    let ownerPrivateKey = "APrivateKey1zkpJkyYRGYtkeHDaFfwsKtUJzia7csiWhfBWPXWhXJzy9Ls"
    let ownerAddress = "aleo1j7qxyunfldj2lp8hsvy7mw5k8zaqgjfyr72x2gh3x4ewgae8v5gscf5jh3"
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testToAndFromString() throws {
        let record = RecordCiphertext(ownerCiphertext)!
        
        XCTAssertEqual("\(record)", ownerCiphertext)
    }
    
    func testInvalidStrings() throws {
        let invalidBech32 = "record2qqj3a67efazf0awe09grqqg44htnh9vaw7l729vl309c972x7ldquqq2k2cax8s7qsqqyqtpgvqqyqsq4seyrzvfa98fkggzccqr68af8e9m0q8rzeqh8a8aqql3a854v58sgrygdv4jn9s8ckwfd48vujrmv0rtfasqh8ygn88ch34ftck8szspvfpsqqszqzvxx9t8s9g66teeepgxmvnw5ymgapcwt2lpy9d5eus580k08wpq544jcl437wjv206u5pxst6few9ll4yhufwldgpx80rlwq8nhssqywmfsd85skg564vqhm3gxsp8q6r30udmqxrxmxx2v8xycdg8pn5ps3dhfvv"
        
        XCTAssertNil(RecordCiphertext(invalidBech32))
    }
    
    func testDecrypt() throws {
        let record = RecordCiphertext(ownerCiphertext)!
        let viewKey = ViewKey(ownerViewKey)
        
        let plaintext = record.decrypt(viewKey: viewKey)!
        XCTAssertEqual("\(plaintext)", ownerPlaintext)
        
        let incorrectViewKey = ViewKey(nonOwnerViewKey)
        XCTAssertNil(record.decrypt(viewKey: incorrectViewKey))
    }
    
    func testIsOwner() throws {
        let record = RecordCiphertext(ownerCiphertext)!
        let viewKey = ViewKey(ownerViewKey)
        
        XCTAssert(record.isOwner(viewKey: viewKey))
        
        let incorrectViewKey = ViewKey(nonOwnerViewKey)
        XCTAssertFalse(record.isOwner(viewKey: incorrectViewKey))
    }
}
