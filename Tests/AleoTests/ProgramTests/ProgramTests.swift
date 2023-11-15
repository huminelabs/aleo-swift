//
//  ProgramTests.swift
//
//
//  Created by Nafeh Shoaib on 11/14/23.
//

import XCTest

@testable import Aleo

final class ProgramTests: XCTestCase {
    let tokenIssueProgram = """
    program token_issue.aleo;

    struct token_metadata:
        token_id as u32;
        version as u32;

    record Token:
        owner as address.private;
        microcredits as u64.private;
        amount as u64.private;
        token_data as token_metadata.private;

    function issue:
        input r0 as address.private;
        input r1 as u64.private;
        input r2 as token_metadata.private;
        assert.eq self.caller aleo1t0uer3jgtsgmx5tq6x6f9ecu8tr57rzzfnc2dgmcqldceal0ls9qf6st7a;
        cast r0 0u64 r1 r2 into r3 as Token.record;
        output r3 as Token.record;

    function bump_token_version:
        input r0 as address.private;
        input r1 as Token.record;
        input r2 as token_metadata.private;
        assert.eq r1 r3.owner;
        cast r0 r1.microcredits r1.amount r2 into r3 as Token.record;
        output r3 as Token.record;
    """

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        guard let program = Program.creditsProgram else {
            fatalError()
        }
        
        let f = program.functions
        print("fArray: \(f)")
//        print("""
//        Program mappings: \(program?.mappings?.map({ $0.name }).joined(separator: ","))
//        """)
    }
    
    func testBuildTransaction() async throws {
        let privateKey = PrivateKey()
        let transaction = ProgramManager.execute(privateKey: privateKey, program: "hello_hello.aleo", function: "hello_hello", inputs: ["5u32", "5u32"], feeCredits: 0.020, feeRecord: <#T##RecordPlaintext#>, url: nil, imports: [], provingKey: nil, verifyingKey: nil, feeProvingKey: nil, feeVerifyingKey: nil)
    }

}
