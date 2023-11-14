//
//  Transaction.swift
//
//
//  Created by Nafeh Shoaib on 11/11/23.
//

import Foundation

public struct Transaction: LosslessStringConvertible {
    
    internal var rustTransaction: RTransaction
    
    public var id: String {
        rustTransaction.r_transaction_id().toString()
    }
    
    public var type: String {
        rustTransaction.r_transaction_type().toString()
    }
    
    public var description: String {
        toString()
    }
    
    internal init(rustTransaction: RTransaction) {
        self.rustTransaction = rustTransaction
    }
    
    public init?(_ string: String) {
        guard let rustTransaction = RTransaction.r_from_string(string) else {
            return nil
        }
        
        self.init(rustTransaction: rustTransaction)
    }
    
    public func toString() -> String {
        rustTransaction.r_to_string().toString()
    }
}
