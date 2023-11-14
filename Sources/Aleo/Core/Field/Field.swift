//
//  Field.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

public struct Field: Equatable, LosslessStringConvertible {
    internal var rustField: RField
    
    internal init(rustField: RField) {
        self.rustField = rustField
    }
    
    public init?(_ string: String) {
        guard let rustField = RField.r_from_string(string) else {
            return nil
        }
        
        self.init(rustField: rustField)
    }
    
    public var description: String {
        toString()
    }
    
    public func toString() -> String {
        rustField.r_to_string().toString()
    }
}
