//
//  RecordPlaintext.swift
//
//
//  Created by Nafeh Shoaib on 10/30/23.
//

import Foundation

/// Plaintext representation of an Aleo record.
public struct RecordPlaintext: LosslessStringConvertible {
    internal var rustRecordPlaintext: RRecordPlaintext
    
    internal init(rustRecordPlaintext: RRecordPlaintext) {
        self.rustRecordPlaintext = rustRecordPlaintext
    }
    
    /// Return a record plaintext from a string.
    ///
    /// - Parameter string: String representation of a plaintext representation of an Aleo record.
    public init?(_ string: String) {
        guard let rustRecordPlaintext = RRecordPlaintext.r_from_string(string) else {
            return nil
        }
        
        self.init(rustRecordPlaintext: rustRecordPlaintext)
    }
    
    public var description: String {
        toString()
    }
    
    /// Returns the record plaintext string.
    ///
    /// - Returns: String representation of the record plaintext.
    public func toString() -> String {
        return rustRecordPlaintext.r_to_string().toString()
    }
    
    /// Returns the amount of microcredits in the record.
    ///
    /// - Returns: Amount of microcredits in the record.
    public var microcredits: Float {
        return Float(rustRecordPlaintext.r_microcredits())
    }
    
    /// Returns the nonce of the record.
    ///
    /// This can be used to uniquely identify a record.
    ///
    /// - Returns: Nonce of the record.
    public var nonce: String {
        return rustRecordPlaintext.r_nonce().toString()
    }
    
    /// Attempt to get the serial number of a record to determine whether or not is has been spent.
    ///
    /// - Parameters:
    ///    - privateKey: Private key of the account that owns the record.
    ///    - programID: Program ID of the program that the record is associated with.
    ///    - recordName: Name of the record.
    /// - Returns: Serial number of the record.
    public func serialNumber(privateKey: PrivateKey, programID: String, recordName: String) -> String? {
        return rustRecordPlaintext.r_serial_number_string(privateKey.rustPrivateKey, programID, recordName)?.toString()
    }
    
    public func commitment(programID: String, recordName: String) -> Field? {
        guard let rustField = rustRecordPlaintext.r_commitment(programID, recordName) else {
            return nil
        }
        
        return Field(rustField: rustField)
    }
}
