//
//  Program.swift
//
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import Foundation

/// Swift <-> Rust Representation of an Aleo program
///
/// This object is required to create an Execution or Deployment transaction. It includes several
/// convenience methods for enumerating available functions and each functions' inputs in a
/// javascript object for usage in creation of web forms for input capture.
public struct Program: Equatable, LosslessStringConvertible {
    
    internal var rustProgram: RProgram
    
    internal init(rustProgram: RProgram) {
        self.rustProgram = rustProgram
    }
    
    /// Create a program from a program string
    ///
    /// - Parameter {string} program Aleo program source code
    /// - Returns: {Program | Error} Program object
    public init?(_ string: String) {
        guard let rustProgram = RProgram.r_from_string(string) else {
            return nil
        }
        
        self.init(rustProgram: rustProgram)
    }
    
    public var description: String {
        toString()
    }
    
    /// Get the credits.aleo program
    ///
    /// - Returns: {Program} The credits.aleo program
    public static var creditsProgram: Program {
        let rProgram = RProgram.r_get_credits_program()
        
        return Program(rustProgram: rProgram)
    }
    
    /// Get the id of the program
    ///
    /// - Returns: {string} The id of the program
    public var id: String {
        rustProgram.r_id().toString()
    }
    
    /// Get a string representation of the program
    ///
    /// - Returns: {string} String containing the program source code
    public func toString() -> String {
        rustProgram.r_to_string().toString()
    }
    
    /// Determine if a function is present in the program
    ///
    /// - Parameter {string} functionName Name of the function to check for
    /// - Returns: {boolean} True if the program is valid, false otherwise
    public func hasFunction(with name: String) -> Bool {
        rustProgram.r_has_function(name)
    }
    
    /// Get javascript array of functions names in the program
    ///
    /// - Returns: {Array} Array of all function names present in the program
    ///
    /// ```
    /// const expected_functions = [
    ///   "mint",
    ///   "transfer_private",
    ///   "transfer_private_to_public",
    ///   "transfer_public",
    ///   "transfer_public_to_private",
    ///   "join",
    ///   "split",
    ///   "fee"
    /// ]
    ///
    /// const credits_program = aleo_wasm.Program.getCreditsProgram();
    /// const credits_functions = credits_program.getFunctions();
    /// console.log(credits_functions === expected_functions); // Output should be "true"
    /// ```
    public func getFunctions() -> [String] {
        Array(_immutableCocoaArray: rustProgram.r_get_functions())
    }
    
    /// Get a javascript object representation of the function inputs and types. This can be used
    /// to generate a web form to capture user inputs for an execution of a function.
    ///
    /// - Parameter {string} function_name Name of the function to get inputs for
    /// - Returns: {Array | Error} Array of function inputs
    ///
    /// ```
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
    ///
    /// const credits_program = aleo_wasm.Program.getCreditsProgram();
    /// const transfer_function_inputs = credits_program.getFunctionInputs("transfer_private");
    /// console.log(transfer_function_inputs === expected_inputs); // Output should be "true"
    /// ```
    public func getFunctionInputs(of name: String) -> String? {
        rustProgram.r_get_function_inputs(name)?.toString()
    }
    
    /// Get a the list of a program's mappings and the names/types of their keys and values.
    ///
    /// - Returns: {Array | Error} - An array of objects representing the mappings in the program
    ///
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
    ///
    /// const credits_program = aleo_wasm.Program.getCreditsProgram();
    /// const credits_mappings = credits_program.getMappings();
    /// console.log(credits_mappings === expected_mappings); // Output should be "true"
    /// ```
    public func getMappings() -> String? {
        rustProgram.r_get_mappings()?.toString()
    }
    
    /// Get a javascript object representation of a program record and its types
    ///
    /// - Parameter {string} record_name Name of the record to get members for
    /// - Returns: {Object | Error} Object containing the record name, type, and members
    ///
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
    ///
    /// const credits_program = aleo_wasm.Program.getCreditsProgram();
    /// const credits_record = credits_program.getRecordMembers("Credits");
    /// console.log(credits_record === expected_record); // Output should be "true"
    /// ```
    public func getRecordMembers(for name: String) -> String? {
        rustProgram.r_get_record_members(name)?.toString()
    }
    
    /// Get a javascript object representation of a program struct and its types
    ///
    /// - Parameter {string} struct_name Name of the struct to get members for
    /// - Returns: {Array | Error} Array containing the struct members
    ///
    /// ```
    /// const STRUCT_PROGRAM = "program token_issue.aleo;
    ///
    /// struct token_metadata:
    ///     network as u32;
    ///     version as u32;
    ///
    /// struct token:
    ///     token_id as u32;
    ///     metadata as token_metadata;
    ///
    /// function no_op:
    ///    input r0 as u64;
    ///    output r0 as u64;"
    ///
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
    ///
    /// const program = aleo_wasm.Program.fromString(STRUCT_PROGRAM);
    /// const struct_members = program.getStructMembers("token");
    /// console.log(struct_members === expected_struct_members); // Output should be "true"
    /// ```
    public func getStructMembers(for name: String) -> String? {
        rustProgram.r_get_struct_members(name)?.toString()
    }
    
    /// Get program_imports
    ///
    /// - Returns: {Array} The program imports
    ///
    /// ```
    /// const DOUBLE_TEST = "import multiply_test.aleo;
    ///
    /// program double_test.aleo;
    ///
    /// function double_it:
    ///     input r0 as u32.private;
    ///     call multiply_test.aleo/multiply 2u32 r0 into r1;
    ///     output r1 as u32.private;";
    ///
    /// const expected_imports = [
    ///    "multiply_test.aleo"
    /// ];
    ///
    /// const program = aleo_wasm.Program.fromString(DOUBLE_TEST_PROGRAM);
    /// const imports = program.getImports();
    /// console.log(imports === expected_imports); // Output should be "true"
    /// ```
    public func getImports() -> String? {
        rustProgram.r_get_imports()?.toString()
    }
}
