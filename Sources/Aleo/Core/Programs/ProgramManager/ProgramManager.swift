//
//  File.swift
//  
//
//  Created by Nafeh Shoaib on 11/15/23.
//

import Foundation

public struct ProgramManager {
    internal var rustProgramManager: RProgramManager
    
    internal init(rustProgramManager: RProgramManager) {
        self.rustProgramManager = rustProgramManager
    }
    
    public func execute(privateKey: PrivateKey, program: String, function: String, inputs: [String], feeCredits: Float, feeRecord: RecordPlaintext, url: String?, imports: [String: String] = [:], provingKey: ProvingKey?, verifyingKey: VerifyingKey?, feeProvingKey: ProvingKey?, feeVerifyingKey: VerifyingKey?) async throws {
        
    }
}
