// use crate::types::native::{
//     CurrentNetwork, EntryType, IdentifierNative, PlaintextType, ProgramNative, ValueType,
// };

// use js_sys::{Array, Object, Reflect};
// use snarkvm_console::{network::Testnet3, program::Itertools};
// use snarkvm_synthesizer::{program::FunctionCore, Command};
// use std::{ops::Deref, str::FromStr};
// use wasm_bindgen::JsValue;

// #[swift_bridge::bridge]
// pub mod ffi_program {
//     extern "Rust" {
//         #[swift_bridge(Equatable)]
//         type RProgram;

//         #[swift_bridge(already_declared)]
//         type RProvingKey;
//         #[swift_bridge(already_declared)]
//         type RVerifyingKey;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_from_string(program: &str) -> Option<RProgram>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_to_string(self: &RProgram) -> String;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_has_function(self: &RProgram, function_name: &str) -> bool;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_functions(self: &RProgram) -> String;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_function_inputs(self: &RProgram, function_name: String)
//             -> Option<Vec<String>>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_mappings(self: &RProgram) -> Option<String>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_record_members(self: &RProgram, record_name: String) -> Option<String>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_struct_members(self: &RProgram, struct_name: String) -> Option<String>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_credits_program() -> Option<RProgram>;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_id(self: &RProgram) -> String;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_is_equal(self: &RProgram, other: &RProgram) -> bool;

//         #[swift_bridge(associated_to = RProgram)]
//         pub fn r_get_imports(self: &RProgram) -> Vec<String>;
//     }
// }

// /// Swift <-> Rust Representation of an Aleo program
// ///
// /// This object is required to create an Execution or Deployment transaction. It includes several
// /// convenience methods for enumerating available functions and each functions' inputs in a
// /// javascript object for usage in creation of web forms for input capture.
// #[derive(Clone, Debug, PartialEq, Eq)]
// pub struct RProgram(ProgramNative);

// // pub struct RProgramFunctionInput {
// //     plaintext: &PlaintextType<CurrentNetwork>,
// //     visibility: Option<String>,
// //     name: Option<String>,
// // }

// impl RProgram {
//     /// Create a program from a program string
//     ///
//     /// @param {string} program Aleo program source code
//     /// @returns {Program | Error} Program object
//     pub fn r_from_string(program: &str) -> Option<RProgram> {
//         if let Some(p) = ProgramNative::from_str(program).ok() {
//             Some(Self(p))
//         } else {
//             None
//         }
//     }

//     /// Get a string representation of the program
//     ///
//     /// @returns {string} String containing the program source code
//     #[allow(clippy::inherent_to_string)]
//     pub fn r_to_string(&self) -> String {
//         self.0.to_string()
//     }

//     /// Determine if a function is present in the program
//     ///
//     /// @param {string} functionName Name of the function to check for
//     /// @returns {boolean} True if the program is valid, false otherwise
//     pub fn r_has_function(&self, function_name: &str) -> bool {
//         IdentifierNative::from_str(function_name)
//             .map_or(false, |identifier| self.0.contains_function(&identifier))
//     }

//     /// Get javascript array of functions names in the program
//     ///
//     /// @returns {Array} Array of all function names present in the program
//     ///
//     /// @example
//     /// const expected_functions = [
//     ///   "mint",
//     ///   "transfer_private",
//     ///   "transfer_private_to_public",
//     ///   "transfer_public",
//     ///   "transfer_public_to_private",
//     ///   "join",
//     ///   "split",
//     ///   "fee"
//     /// ]
//     ///
//     /// const credits_program = aleo_wasm.Program.getCreditsProgram();
//     /// const credits_functions = credits_program.getFunctions();
//     /// console.log(credits_functions === expected_functions); // Output should be "true"
//     pub fn r_get_functions(&self) -> String {
//         let mut array: Vec<String> = Vec::with_capacity(self.0.functions().len() as usize);
//         self.0.functions().values().for_each(|function| {
//             let f = &function.name().to_string();
//             array.push(f.to_string());
//         });
//         return array.join(",");
//     }

//     /// Get a javascript object representation of the function inputs and types. This can be used
//     /// to generate a web form to capture user inputs for an execution of a function.
//     ///
//     /// @param {string} function_name Name of the function to get inputs for
//     /// @returns {Array | Error} Array of function inputs
//     ///
//     /// @example
//     /// const expected_inputs = [
//     ///     {
//     ///       type:"record",
//     ///       visibility:"private",
//     ///       record:"credits",
//     ///       members:[
//     ///         {
//     ///           name:"microcredits",
//     ///           type:"u64",
//     ///           visibility:"private"
//     ///         }
//     ///       ],
//     ///       register:"r0"
//     ///     },
//     ///     {
//     ///       type:"address",
//     ///       visibility:"private",
//     ///       register:"r1"
//     ///     },
//     ///     {
//     ///       type:"u64",
//     ///       visibility:"private",
//     ///       register:"r2"
//     ///     }
//     /// ];
//     ///
//     /// const credits_program = aleo_wasm.Program.getCreditsProgram();
//     /// const transfer_function_inputs = credits_program.getFunctionInputs("transfer_private");
//     /// console.log(transfer_function_inputs === expected_inputs); // Output should be "true"
//     pub fn r_get_function_inputs(&self, function_name: String) -> Option<Vec<String>> {
//         if let Some(function_id) = IdentifierNative::from_str(&function_name).ok() {
//             if let Some(function) = self.0.functions().get(&function_id) {
//                 Some(
//                     function
//                         .inputs()
//                         .iter()
//                         .map(|input| input.to_string())
//                         .collect(),
//                 )
//             } else {
//                 None
//             }
//         } else {
//             None
//         }
//     }

//     pub fn get_function_inputs(&self, function_name: String) -> Result<Array, String> {
//         let function_id = IdentifierNative::from_str(&function_name).map_err(|e| e.to_string())?;
//         let function =
//             self.0.functions().get(&function_id).ok_or_else(|| {
//                 format!("function {} not found in {}", function_name, self.0.id())
//             })?;
//         let function_inputs = Array::new_with_length(function.inputs().len() as u32);
//         for (index, input) in function.inputs().iter().enumerate() {
//             let register = JsValue::from_str(&input.register().to_string());
//             match input.value_type() {
//                 ValueType::Constant(plaintext) => {
//                     function_inputs.set(index as u32, {
//                         let input = self.get_plaintext_input(
//                             plaintext,
//                             Some("constant".to_string()),
//                             None,
//                         )?;
//                         Reflect::set(&input, &"register".into(), &register)
//                             .map_err(|_| "Failed to set property")?;
//                         input.into()
//                     });
//                 }
//                 ValueType::Public(plaintext) => {
//                     function_inputs.set(index as u32, {
//                         let input =
//                             self.get_plaintext_input(plaintext, Some("public".to_string()), None)?;
//                         Reflect::set(&input, &"register".into(), &register)
//                             .map_err(|_| "Failed to set property")?;
//                         input.into()
//                     });
//                 }
//                 ValueType::Private(plaintext) => {
//                     function_inputs.set(index as u32, {
//                         let input =
//                             self.get_plaintext_input(plaintext, Some("private".to_string()), None)?;
//                         Reflect::set(&input, &"register".into(), &register)
//                             .map_err(|_| "Failed to set property")?;
//                         input.into()
//                     });
//                 }
//                 ValueType::Record(identifier) => {
//                     function_inputs.set(index as u32, {
//                         let input = self.get_record_members(identifier.to_string())?;
//                         Reflect::set(&input, &"register".into(), &register)
//                             .map_err(|_| "Failed to set property")?;
//                         input.into()
//                     });
//                 }
//                 ValueType::ExternalRecord(locator) => {
//                     let input = Object::new();
//                     let value_type = JsValue::from_str("external_record");
//                     Reflect::set(&input, &"type".into(), &value_type)
//                         .map_err(|_| "Failed to set property")?;
//                     Reflect::set(&input, &"locator".into(), &locator.to_string().into())
//                         .map_err(|_| "Failed to set property")?;
//                     Reflect::set(&input, &"register".into(), &register)
//                         .map_err(|_| "Failed to set property")?;
//                     function_inputs.set(index as u32, input.into());
//                 }
//                 ValueType::Future(locator) => {
//                     let input = Object::new();
//                     let value_type = JsValue::from_str("future");
//                     Reflect::set(&input, &"type".into(), &value_type)
//                         .map_err(|_| "Failed to set property")?;
//                     Reflect::set(&input, &"locator".into(), &locator.to_string().into())
//                         .map_err(|_| "Failed to set property")?;
//                     Reflect::set(&input, &"register".into(), &register)
//                         .map_err(|_| "Failed to set property")?;
//                     function_inputs.set(index as u32, input.into());
//                 }
//             }
//         }
//         Ok(function_inputs)
//     }

//     /// Get a the list of a program's mappings and the names/types of their keys and values.
//     ///
//     /// @returns {Array | Error} - An array of objects representing the mappings in the program
//     /// @example
//     /// const expected_mappings = [
//     ///    {
//     ///       name: "account",
//     ///       key_name: "owner",
//     ///       key_type: "address",
//     ///       value_name: "microcredits",
//     ///       value_type: "u64"
//     ///    }
//     /// ]
//     ///
//     /// const credits_program = aleo_wasm.Program.getCreditsProgram();
//     /// const credits_mappings = credits_program.getMappings();
//     /// console.log(credits_mappings === expected_mappings); // Output should be "true"
//     pub fn r_get_mappings(&self) -> Option<String> {
//         if let Some(array) = self.get_mappings().ok() {
//             array.to_string().as_string()
//         } else {
//             None
//         }
//     }

//     pub fn get_mappings(&self) -> Result<Array, String> {
//         let mappings = Array::new();

//         // Set the mapping name and key/value names & types
//         self.0.mappings().iter().try_for_each(|(name, mapping)| {
//             let mapping_object = Object::new();
//             Reflect::set(&mapping_object, &"name".into(), &name.to_string().into())
//                 .map_err(|_| "Failed to set property")?;
//             Reflect::set(
//                 &mapping_object,
//                 &"key_type".into(),
//                 &mapping.key().plaintext_type().to_string().into(),
//             )
//             .map_err(|_| "Failed to set property")?;
//             Reflect::set(
//                 &mapping_object,
//                 &"value_type".into(),
//                 &mapping.value().plaintext_type().to_string().into(),
//             )
//             .map_err(|_| "Failed to set property")?;
//             mappings.push(&mapping_object);
//             Ok::<(), String>(())
//         })?;
//         Ok(mappings)
//     }

//     // Get the value of a plaintext input as a javascript object (this function is not part of the
//     // public API)
//     fn get_plaintext_input(
//         &self,
//         plaintext: &PlaintextType<CurrentNetwork>,
//         visibility: Option<String>,
//         name: Option<String>,
//     ) -> Result<Object, String> {
//         let input = Object::new();
//         match plaintext {
//             PlaintextType::Array(array_type) => {
//                 if let Some(name) = name {
//                     Reflect::set(&input, &"name".into(), &name.into())
//                         .map_err(|_| "Failed to set property")?;
//                 }
//                 Reflect::set(&input, &"type".into(), &"array".into())
//                     .map_err(|_| "Failed to set property")?;

//                 // Set the element types of the Array and record the length
//                 let element_type =
//                     self.get_plaintext_input(array_type.base_element_type(), None, None)?;
//                 let length = **array_type.length();
//                 Reflect::set(&input, &"element_type".into(), &element_type)
//                     .map_err(|_| "Failed to set property")?;
//                 Reflect::set(&input, &"length".into(), &length.into())
//                     .map_err(|_| "Failed to set property")?;
//             }
//             PlaintextType::Literal(literal_type) => {
//                 if let Some(name) = name {
//                     Reflect::set(&input, &"name".into(), &name.into())
//                         .map_err(|_| "Failed to set property")?;
//                 }
//                 let value_type = JsValue::from_str(&literal_type.to_string());
//                 Reflect::set(&input, &"type".into(), &value_type)
//                     .map_err(|_| "Failed to set property")?;
//             }
//             PlaintextType::Struct(struct_id) => {
//                 let struct_name = struct_id.to_string();
//                 if let Some(name) = name {
//                     Reflect::set(&input, &"name".into(), &name.into())
//                         .map_err(|_| "Failed to set property")?;
//                 }
//                 Reflect::set(&input, &"type".into(), &"struct".into())
//                     .map_err(|_| "Failed to set property")?;
//                 Reflect::set(&input, &"struct_id".into(), &struct_name.as_str().into())
//                     .map_err(|_| "Failed to set property")?;
//                 let inputs = self.get_struct_members(struct_name)?;
//                 Reflect::set(&input, &"members".into(), &inputs.into())
//                     .map_err(|_| "Failed to set property")?;
//             }
//         }
//         if let Some(visibility) = visibility {
//             Reflect::set(&input, &"visibility".into(), &visibility.into())
//                 .map_err(|_| "Failed to set property")?;
//         }

//         Ok(input)
//     }

//     /// Get a javascript object representation of a program record and its types
//     ///
//     /// @param {string} record_name Name of the record to get members for
//     /// @returns {Object | Error} Object containing the record name, type, and members
//     ///
//     /// @example
//     ///
//     /// const expected_record = {
//     ///     type: "record",
//     ///     record: "Credits",
//     ///     members: [
//     ///       {
//     ///         name: "owner",
//     ///         type: "address",
//     ///         visibility: "private"
//     ///       },
//     ///       {
//     ///         name: "microcredits",
//     ///         type: "u64",
//     ///         visibility: "private"
//     ///       }
//     ///     ];
//     ///  };
//     ///
//     /// const credits_program = aleo_wasm.Program.getCreditsProgram();
//     /// const credits_record = credits_program.getRecordMembers("Credits");
//     /// console.log(credits_record === expected_record); // Output should be "true"
//     pub fn r_get_record_members(&self, record_name: String) -> Option<String> {
//         if let Some(object) = self.get_record_members(record_name).ok() {
//             object.to_string().as_string()
//         } else {
//             None
//         }
//     }

//     pub fn get_record_members(&self, record_name: String) -> Result<Object, String> {
//         let record_id = IdentifierNative::from_str(&record_name).map_err(|e| e.to_string())?;
//         let record = self
//             .0
//             .get_record(&record_id)
//             .map_err(|_| format!("struct {} not found in {}", record_name, self.0.id()))?;

//         let input = Object::new();
//         Reflect::set(&input, &"type".into(), &"record".into())
//             .map_err(|_| "Failed to set property")?;
//         Reflect::set(&input, &"record".into(), &record_name.into())
//             .map_err(|_| "Failed to set property")?;

//         let record_members = Array::new_with_length(record.entries().len() as u32);

//         for (index, (name, member_type)) in record.entries().iter().enumerate() {
//             match member_type {
//                 EntryType::Constant(plaintext) => record_members.set(
//                     index as u32,
//                     self.get_plaintext_input(
//                         plaintext,
//                         Some("constant".to_string()),
//                         Some(name.to_string()),
//                     )?
//                     .into(),
//                 ),
//                 EntryType::Public(plaintext) => record_members.set(
//                     index as u32,
//                     self.get_plaintext_input(
//                         plaintext,
//                         Some("public".to_string()),
//                         Some(name.to_string()),
//                     )?
//                     .into(),
//                 ),
//                 EntryType::Private(plaintext) => record_members.set(
//                     index as u32,
//                     self.get_plaintext_input(
//                         plaintext,
//                         Some("private".to_string()),
//                         Some(name.to_string()),
//                     )?
//                     .into(),
//                 ),
//             }
//         }

//         Reflect::set(&input, &"members".into(), &record_members)
//             .map_err(|_| "Failed to set property")?;

//         // Adding _nonce object to record
//         let _nonce = Object::new();
//         Reflect::set(&_nonce, &"name".into(), &"_nonce".into())
//             .map_err(|_| "Failed to set property")?;
//         Reflect::set(&_nonce, &"type".into(), &"group".into())
//             .map_err(|_| "Failed to set property")?;
//         Reflect::set(&_nonce, &"visibility".into(), &"public".into())
//             .map_err(|_| "Failed to set property")?;

//         record_members.push(&JsValue::from(_nonce));

//         Ok(input)
//     }

//     /// Get a javascript object representation of a program struct and its types
//     ///
//     /// @param {string} struct_name Name of the struct to get members for
//     /// @returns {Array | Error} Array containing the struct members
//     ///
//     /// @example
//     ///
//     /// const STRUCT_PROGRAM = "program token_issue.aleo;
//     ///
//     /// struct token_metadata:
//     ///     network as u32;
//     ///     version as u32;
//     ///
//     /// struct token:
//     ///     token_id as u32;
//     ///     metadata as token_metadata;
//     ///
//     /// function no_op:
//     ///    input r0 as u64;
//     ///    output r0 as u64;"
//     ///
//     /// const expected_struct_members = [
//     ///    {
//     ///      name: "token_id",
//     ///      type: "u32",
//     ///    },
//     ///    {
//     ///      name: "metadata",
//     ///      type: "struct",
//     ///      struct_id: "token_metadata",
//     ///      members: [
//     ///       {
//     ///         name: "network",
//     ///         type: "u32",
//     ///       }
//     ///       {
//     ///         name: "version",
//     ///         type: "u32",
//     ///       }
//     ///     ]
//     ///   }
//     /// ];
//     ///
//     /// const program = aleo_wasm.Program.fromString(STRUCT_PROGRAM);
//     /// const struct_members = program.getStructMembers("token");
//     /// console.log(struct_members === expected_struct_members); // Output should be "true"
//     pub fn r_get_struct_members(&self, struct_name: String) -> Option<String> {
//         if let Some(array) = self.get_struct_members(struct_name).ok() {
//             array.to_string().as_string()
//         } else {
//             None
//         }
//     }

//     pub fn get_struct_members(&self, struct_name: String) -> Result<Array, String> {
//         let struct_id = IdentifierNative::from_str(&struct_name).map_err(|e| e.to_string())?;

//         let program_struct = self
//             .0
//             .get_struct(&struct_id)
//             .map_err(|_| format!("struct {} not found in {}", struct_name, self.0.id()))?;

//         let struct_members = Array::new_with_length(program_struct.members().len() as u32);
//         for (index, (name, member_type)) in program_struct.members().iter().enumerate() {
//             let input = self.get_plaintext_input(member_type, None, Some(name.to_string()))?;
//             struct_members.set(index as u32, input.into());
//         }

//         Ok(struct_members)
//     }

//     /// Get the credits.aleo program
//     ///
//     /// @returns {Program} The credits.aleo program
//     pub fn r_get_credits_program() -> Option<RProgram> {
//         if let Some(program) = ProgramNative::credits().ok() {
//             Some(RProgram::from(program))
//         } else {
//             None
//         }
//     }

//     /// Get the id of the program
//     ///
//     /// @returns {string} The id of the program
//     pub fn r_id(&self) -> String {
//         self.0.id().to_string()
//     }

//     /// Determine equality with another program
//     ///
//     /// @param {Program} other The other program to compare
//     /// @returns {boolean} True if the programs are equal, false otherwise
//     pub fn r_is_equal(&self, other: &RProgram) -> bool {
//         self == other
//     }

//     /// Get program_imports
//     ///
//     /// @returns {Array} The program imports
//     ///
//     /// @example
//     ///
//     /// const DOUBLE_TEST = "import multiply_test.aleo;
//     ///
//     /// program double_test.aleo;
//     ///
//     /// function double_it:
//     ///     input r0 as u32.private;
//     ///     call multiply_test.aleo/multiply 2u32 r0 into r1;
//     ///     output r1 as u32.private;";
//     ///
//     /// const expected_imports = [
//     ///    "multiply_test.aleo"
//     /// ];
//     ///
//     /// const program = aleo_wasm.Program.fromString(DOUBLE_TEST_PROGRAM);
//     /// const imports = program.getImports();
//     /// console.log(imports === expected_imports); // Output should be "true"
//     pub fn r_get_imports(&self) -> Vec<String> {
//         self.0
//             .imports()
//             .values()
//             .map(|import| import.to_string())
//             .collect()
//     }

//     pub fn get_imports(&self) -> Array {
//         let imports = Array::new_with_length(self.0.imports().len() as u32);
//         for (index, (import, _)) in self.0.imports().iter().enumerate() {
//             imports.set(index as u32, import.to_string().into());
//         }
//         imports
//     }
// }

// // struct RProgramFunctionInputPlaintext {
// //     typeString: String,
// //     visibility: String,
// //     record: String,
// //     members: [RProgramMember],
// // }

// // struct RProgramMember {}

// // impl RProgramFunctionInput {
// //     pub fn r_get_type(&self) {
// //         match self.plaintext {
// //             PlaintextType::Array(array_type) => {
// //                 if let Some(name) = self.name {
// //                     Reflect::set(&input, &"name".into(), &name.into())
// //                         .map_err(|_| "Failed to set property")?;
// //                 }
// //                 Reflect::set(&input, &"type".into(), &"array".into())
// //                     .map_err(|_| "Failed to set property")?;

// //                 // Set the element types of the Array and record the length
// //                 let element_type =
// //                     self.get_plaintext_input(array_type.base_element_type(), None, None)?;
// //                 let length = **array_type.length();
// //                 Reflect::set(&input, &"element_type".into(), &element_type)
// //                     .map_err(|_| "Failed to set property")?;
// //                 Reflect::set(&input, &"length".into(), &length.into())
// //                     .map_err(|_| "Failed to set property")?;
// //             }
// //             PlaintextType::Literal(literal_type) => {
// //                 if let Some(name) = self.name {
// //                     Reflect::set(&input, &"name".into(), &name.into())
// //                         .map_err(|_| "Failed to set property")?;
// //                 }
// //                 let value_type = JsValue::from_str(&literal_type.to_string());
// //                 Reflect::set(&input, &"type".into(), &value_type)
// //                     .map_err(|_| "Failed to set property")?;
// //             }
// //             PlaintextType::Struct(struct_id) => {
// //                 let struct_name = struct_id.to_string();
// //                 if let Some(name) = self.name {
// //                     Reflect::set(&input, &"name".into(), &name.into())
// //                         .map_err(|_| "Failed to set property")?;
// //                 }
// //                 Reflect::set(&input, &"type".into(), &"struct".into())
// //                     .map_err(|_| "Failed to set property")?;
// //                 Reflect::set(&input, &"struct_id".into(), &struct_name.as_str().into())
// //                     .map_err(|_| "Failed to set property")?;
// //                 let inputs = self.get_struct_members(struct_name)?;
// //                 Reflect::set(&input, &"members".into(), &inputs.into())
// //                     .map_err(|_| "Failed to set property")?;
// //             }
// //         }
// //     }

// //     pub fn r_get_visibility(&self) -> String {}

// //     pub fn r_get_record(&self) -> String {}

// //     pub fn r_get_members(&self) -> Vec<RProgramMember> {}

// //     pub fn r_get_register(&self) -> String {}
// // }

// impl Deref for RProgram {
//     type Target = ProgramNative;

//     fn deref(&self) -> &Self::Target {
//         &self.0
//     }
// }

// impl From<ProgramNative> for RProgram {
//     fn from(value: ProgramNative) -> Self {
//         Self(value)
//     }
// }

// impl From<RProgram> for ProgramNative {
//     fn from(program: RProgram) -> Self {
//         program.0
//     }
// }

// impl FromStr for RProgram {
//     type Err = String;

//     fn from_str(s: &str) -> Result<Self, Self::Err> {
//         Self::r_from_string(s).ok_or("Error in converting from string".to_string())
//     }
// }
