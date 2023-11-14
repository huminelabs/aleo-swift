//
//  RecordPlaintextTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/2/23.
//

import XCTest

@testable import Aleo

final class RecordPlaintextTests: XCTestCase {
    
    let recordString = """
    {
      owner: aleo1j7qxyunfldj2lp8hsvy7mw5k8zaqgjfyr72x2gh3x4ewgae8v5gscf5jh3.private,
      microcredits: 1500000000000000u64.private,
      _nonce: 3077450429259593211617823051143573281856129402760267155982965992208217472983group.public
    }
    """
    
    let privateKey = PrivateKey("APrivateKey1zkpDeRpuKmEtLNPdv57aFruPepeH1aGvTkEjBo8bqTzNUhE")
    
    let programID = "credits.aleo"
    let recordName = "credits"
    let expectedSerialNumber = "8170619507075647151199239049653235187042661744691458644751012032123701508940field"
    
    var record: RecordPlaintext? {
        return .init(recordString)
    }

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testToAndFromString() throws {
        XCTAssertEqual("\(record!)", recordString)
    }
    
    func testMicrocreditsFromString() throws {
        XCTAssertEqual(record!.microcredits, 1_500_000_000_000_000)
    }
    
    func testSerialNumber() throws {
        let result = record!.serialNumber(privateKey: privateKey!, programID: programID, recordName: recordName)
        
        XCTAssertEqual(expectedSerialNumber, result)
    }
    
    func testSerialNumberCanRunTwiceWithSamePrivateKey() throws {
        XCTAssertEqual(expectedSerialNumber, record!.serialNumber(privateKey: privateKey!, programID: programID, recordName: recordName))
        XCTAssertEqual(expectedSerialNumber, record!.serialNumber(privateKey: privateKey!, programID: programID, recordName: recordName))
    }
    
    func testSerialNumberInvalidProgramID() throws {
        let wrongProgramID = "not a real program ID"
        let newRecordName = "token"
        
        XCTAssertNil(record!.serialNumber(privateKey: privateKey!, programID: wrongProgramID, recordName: newRecordName))
    }
    
    func testSerialNumberInvalidRecordName() throws {
        let newProgramID = "token.aleo"
        let wrongRecordName = "not a real record name"
        
        XCTAssertNil(record!.serialNumber(privateKey: privateKey!, programID: newProgramID, recordName: wrongRecordName))
    }
    
    func testBadInputsToAndFromString() throws {
        let invalidBech32 = """
        {
            owner: aleo2d5hg2z3ma00382pngntdp68e74zv54jdxy249qhaujhks9c72yrs33ddah.private,
            microcredits: 99u64.public,
            _nonce: 0group.public
        }
        """
        
        XCTAssertNil(RecordPlaintext("string"))
        XCTAssertNil(RecordPlaintext(invalidBech32))
    }
}
