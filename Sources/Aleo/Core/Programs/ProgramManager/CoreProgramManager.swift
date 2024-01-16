//
//  CoreProgramManager.swift
//
//
//  Created by Nafeh Shoaib on 11/15/23.
//

import Foundation

public struct CoreProgramManager {
    internal var rustProgramManager: RProgramManager
    
    internal init(rustProgramManager: RProgramManager) {
        self.rustProgramManager = rustProgramManager
    }
    
    public static func execute(
        privateKey: PrivateKey,
        program: String,
        function: String,
        inputs: [String],
        feeCredits: Float,
        feeRecord: RecordPlaintext?,
        url: String?,
        imports: [String: String] = [:],
        provingKey: ProvingKey?,
        verifyingKey: VerifyingKey?,
        feeProvingKey: ProvingKey?,
        feeVerifyingKey: VerifyingKey?
    ) async throws -> Transaction? {
        let imports = RStringMap(dictionaryLiteral: imports)
        
        var inputVector = RustVec<RustString>()
        inputs.forEach { i in
            inputVector.push(value: .init(i))
        }
        
        guard let transaction = RProgramManager.r_execute(privateKey.rustPrivateKey, program, function, inputVector, Double(feeCredits), feeRecord?.rustRecordPlaintext, url?.intoRustString(), imports, provingKey?.rustProvingKey, verifyingKey?.rustVerifyingKey, feeProvingKey?.rustProvingKey, feeVerifyingKey?.rustVerifyingKey) else {
            return nil
        }
        
        return Transaction(rustTransaction: transaction)
    }
}
