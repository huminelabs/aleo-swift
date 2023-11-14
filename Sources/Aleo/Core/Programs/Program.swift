//
//  Program.swift
//
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import Foundation

public struct Program: Equatable, LosslessStringConvertible {
    
    internal var rustProgram: RProgram
    
    internal init(rustProgram: RProgram) {
        self.rustProgram = rustProgram
    }
    
    public init?(_ string: String) {
        guard let rustProgram = RProgram.r_from_string(string) else {
            return nil
        }
        
        self.init(rustProgram: rustProgram)
    }
    
    public var description: String {
        toString()
    }
    
    public static var creditsProgram: Program {
        let rProgram = RProgram.r_get_credits_program()
        
        return Program(rustProgram: rProgram)
    }
    
    public var id: String {
        rustProgram.r_id().toString()
    }
    
    public func toString() -> String {
        rustProgram.r_to_string().toString()
    }
    
    public func hasFunction(with name: String) -> Bool {
        rustProgram.r_has_function(name)
    }
    
    public func getFunctions() -> [String] {
        Array(_immutableCocoaArray: rustProgram.r_get_functions())
    }
    
    public func getFunctionInputs(of name: String) -> String? {
        rustProgram.r_get_function_inputs(name)?.toString()
    }
    
    public func getMappings() -> String? {
        rustProgram.r_get_mappings()?.toString()
    }
    
    public func getRecordMembers(for name: String) -> String? {
        rustProgram.r_get_record_members(name)?.toString()
    }
    
    public func getStructMembers(for name: String) -> String? {
        rustProgram.r_get_struct_members(name)?.toString()
    }
    
    public func getImports() -> String? {
        rustProgram.r_get_imports()?.toString()
    }
}
