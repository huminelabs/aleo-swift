// Copyright Humine Labs Inc.

pub mod account;
pub use account::*;

pub mod programs;
pub use programs::*;

pub mod record;
pub use record::*;

pub mod types;

use std::str::FromStr;

use types::native::{
    Entry, IdentifierNative, LiteralNative, PlaintextNative, RecordPlaintextNative,
};

/// A trait providing convenient methods for accessing the amount of Aleo present in a record
pub trait Credits {
    /// Get the amount of credits in the record if the record possesses Aleo credits
    fn credits(&self) -> Result<f64, String> {
        Ok(self.microcredits()? as f64 / 1_000_000.0)
    }

    /// Get the amount of microcredits in the record if the record possesses Aleo credits
    fn microcredits(&self) -> Result<u64, String>;
}

impl Credits for RecordPlaintextNative {
    fn microcredits(&self) -> Result<u64, String> {
        match self
            .find(&[IdentifierNative::from_str("microcredits").map_err(|e| e.to_string())?])
            .map_err(|e| e.to_string())?
        {
            Entry::Private(PlaintextNative::Literal(LiteralNative::U64(amount), _)) => Ok(*amount),
            _ => Err("The record provided does not contain a microcredits field".to_string()),
        }
    }
}
