//
//  RecordCiphertext.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Encrypted Aleo record.
public struct RecordCiphertext: LosslessStringConvertible {
    internal var rustRecordCiphertext: RRecordCiphertext
    
    internal init(rustRecordCiphertext: RRecordCiphertext) {
        self.rustRecordCiphertext = rustRecordCiphertext
    }
    
    /// Create a record ciphertext from a string.
    ///
    /// - Parameter record: String representation of a record ciphertext.
    public init?(_ string: String) {
        guard let rustRecordCiphertext = RRecordCiphertext.r_from(string) else {
            return nil
        }
        
        self.init(rustRecordCiphertext: rustRecordCiphertext)
    }
    
    public var description: String {
        toString()
    }
    
    /// Return the string reprensentation of the record ciphertext.
    ///
    /// - Returns: String representation of the record ciphertext.
    public func toString() -> String {
        self.rustRecordCiphertext.r_to_string().toString()
    }
    
    /// Decrypt the record ciphertext into plaintext using the view key.
    ///
    /// The record will only decrypt if the record was encrypted by the account corresponding to the view key.
    ///
    /// - Parameter viewKey: View key used to decrypt the ciphertext.
    /// - Returns: Record plaintext object.
    public func decrypt(viewKey: ViewKey) -> RecordPlaintext? {
        guard let rustRecordPlaintext = self.rustRecordCiphertext.r_decrypt(viewKey.rustViewKey) else {
            return nil
        }
        
        return RecordPlaintext(rustRecordPlaintext: rustRecordPlaintext)
    }
    
    /// Determines if the account corresponding to the view key is the owner of the record.
    ///
    /// - Parameter viewKey: View key used to decrypt the ciphertext.
    public func isOwner(viewKey: ViewKey) -> Bool {
        return rustRecordCiphertext.r_is_owner(viewKey.rustViewKey)
    }
}
