//
//  Transaction.swift
//
//
//  Created by Nafeh Shoaib on 11/11/23.
//

import Foundation

/// Rust <-> Swift Representation of an Aleo transaction
///
/// This object is created when generating an on-chain function deployment or execution and is the
/// object that should be submitted to the Aleo Network in order to deploy or execute a function.
public struct Transaction: LosslessStringConvertible {
    
    internal var rustTransaction: RTransaction
    
    /// Get the id of the transaction. This is the merkle root of the transaction's inclusion proof.
    ///
    /// This value can be used to query the status of the transaction on the Aleo Network to see
    /// if it was successful. If successful, the transaction will be included in a block and this
    /// value can be used to lookup the transaction data on-chain.
    ///
    /// - Returns: Transaction id
    public var id: String {
        rustTransaction.r_transaction_id().toString()
    }
    
    /// Get the type of the transaction (will return "deploy" or "execute")
    ///
    /// - Returns: Transaction type
    public var type: String {
        rustTransaction.r_transaction_type().toString()
    }
    
    public var description: String {
        toString()
    }
    
    internal init(rustTransaction: RTransaction) {
        self.rustTransaction = rustTransaction
    }
    
    /// Create a transaction from a string
        ///
        /// - Parameter transaction: String representation of a transaction
    public init?(_ string: String) {
        guard let rustTransaction = RTransaction.r_from_string(string) else {
            return nil
        }
        
        self.init(rustTransaction: rustTransaction)
    }
    
    /// Get the transaction as a string. If you want to submit this transaction to the Aleo Network
        /// this function will create the string that should be submitted in the `POST` data.
        ///
        /// - Returns: String representation of the transaction
    public func toString() -> String {
        rustTransaction.r_to_string().toString()
    }
}
