//
//  Program+FunctionInput.swift
//
//
//  Created by Nafeh Shoaib on 11/14/23.
//

import Foundation

extension Program {
    /// Representation of the function inputs and types.
    ///
    /// This can be used to generate a form to capture user inputs for an execution of a function.
    ///
    /// Original JS structure:
    /// ```
    /// @example
    /// const expected_inputs = [
    ///     {
    ///       type:"record",
    ///       visibility:"private",
    ///       record:"credits",
    ///       members:[
    ///         {
    ///           name:"microcredits",
    ///           type:"u64",
    ///           visibility:"private"
    ///         }
    ///       ],
    ///       register:"r0"
    ///     },
    ///     {
    ///       type:"address",
    ///       visibility:"private",
    ///       register:"r1"
    ///     },
    ///     {
    ///       type:"u64",
    ///       visibility:"private",
    ///       register:"r2"
    ///     }
    /// ];
    /// ```
    public struct FunctionInput: Codable {
        public var type: String
        public var record: String?
        public var members: [Member] = []
        public var register: String
    }
    
    public struct Member: Codable {
        public var name: String
        public var type: String
        public var visibility: String?
    }
    
    /// Program's mappings and the names/types of their keys and values.
    ///
    /// Original JS structure:
    /// ```
    /// const expected_mappings = [
    ///    {
    ///       name: "account",
    ///       key_name: "owner",
    ///       key_type: "address",
    ///       value_name: "microcredits",
    ///       value_type: "u64"
    ///    }
    /// ]
    /// ```
    public struct Mapping: Codable {
        enum CodingKeys: String, CodingKey {
            case name, keyName = "key_name", keyType = "key_type", valueName = "value_name", valueType = "value_Type"
        }
        public var name: String
        public var keyName: String
        public var keyType: String
        public var valueName: String
        public var valueType: String
    }
    
    /// Program record and its types.
    ///
    /// Original JS structure:
    /// ```
    /// const expected_record = {
    ///     type: "record",
    ///     record: "Credits",
    ///     members: [
    ///       {
    ///         name: "owner",
    ///         type: "address",
    ///         visibility: "private"
    ///       },
    ///       {
    ///         name: "microcredits",
    ///         type: "u64",
    ///         visibility: "private"
    ///       }
    ///     ];
    ///  };
    /// ```
    public struct Record: Codable {
        public var type: String
        public var record: String
        public var members: [Member] = []
    }
    
    /// Program struct and its types.
    ///
    /// Original JS structure:
    /// ```
    /// const expected_struct_members = [
    ///    {
    ///      name: "token_id",
    ///      type: "u32",
    ///    },
    ///    {
    ///      name: "metadata",
    ///      type: "struct",
    ///      struct_id: "token_metadata",
    ///      members: [
    ///       {
    ///         name: "network",
    ///         type: "u32",
    ///       }
    ///       {
    ///         name: "version",
    ///         type: "u32",
    ///       }
    ///     ]
    ///   }
    /// ];
    /// ```
    public struct StructureMember: Codable {
        enum CodingKeys: String, CodingKey {
            case name, type, structID = "struct_id", members
        }
        
        public var name: String
        public var type: String
        public var structID: String
        public var members: [Member] = []
    }
}
