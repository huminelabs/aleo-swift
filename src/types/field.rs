use super::native::FieldNative;

use std::str::FromStr;

#[swift_bridge::bridge]
pub mod ffi_field {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RField;

        #[swift_bridge(associated_to = RField)]
        pub fn r_to_string(self: &RField) -> String;

        #[swift_bridge(associated_to = RField)]
        pub fn r_from_string(string: &str) -> Option<RField>;
    }
}

/// Aleo Field
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct RField(FieldNative);

pub enum FieldError {
    Passthrough(String),
}

impl RField {
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    pub fn r_from_string(string: &str) -> Option<RField> {
        let native = FieldNative::from_str(string).ok();

        if let Some(native) = native {
            Some(Self(native))
        } else {
            None
        }
    }
}

impl From<FieldNative> for RField {
    fn from(native: FieldNative) -> Self {
        Self(native)
    }
}

impl From<RField> for FieldNative {
    fn from(field: RField) -> Self {
        field.0
    }
}
