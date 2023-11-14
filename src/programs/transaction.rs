use crate::types::native::TransactionNative;

use std::str::FromStr;

#[swift_bridge::bridge]
pub mod ffi_transaction {
    extern "Rust" {
        #[swift_bridge(Equatable)]
        type RTransaction;

        #[swift_bridge(associated_to = RTransaction)]
        pub fn r_from_string(transaction: &str) -> Option<RTransaction>;

        #[swift_bridge(associated_to = RTransaction)]
        pub fn r_to_string(self: &RTransaction) -> String;

        #[swift_bridge(associated_to = RTransaction)]
        pub fn r_transaction_id(self: &RTransaction) -> String;

        #[swift_bridge(associated_to = RTransaction)]
        pub fn r_transaction_type(self: &RTransaction) -> String;
    }
}

/// Rust <-> Swift Representation of an Aleo transaction
///
/// This object is created when generating an on-chain function deployment or execution and is the
/// object that should be submitted to the Aleo Network in order to deploy or execute a function.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RTransaction(TransactionNative);

impl RTransaction {
    /// Create a transaction from a string
    ///
    /// @param {string} transaction String representation of a transaction
    /// @returns {Option<Transaction>}
    pub fn r_from_string(transaction: &str) -> Option<RTransaction> {
        RTransaction::from_str(transaction).ok()
    }

    /// Get the transaction as a string. If you want to submit this transaction to the Aleo Network
    /// this function will create the string that should be submitted in the `POST` data.
    ///
    /// @returns {string} String representation of the transaction
    #[allow(clippy::inherent_to_string)]
    pub fn r_to_string(&self) -> String {
        self.0.to_string()
    }

    /// Get the id of the transaction. This is the merkle root of the transaction's inclusion proof.
    ///
    /// This value can be used to query the status of the transaction on the Aleo Network to see
    /// if it was successful. If successful, the transaction will be included in a block and this
    /// value can be used to lookup the transaction data on-chain.
    ///
    /// @returns {string} Transaction id
    pub fn r_transaction_id(&self) -> String {
        self.0.id().to_string()
    }

    /// Get the type of the transaction (will return "deploy" or "execute")
    ///
    /// @returns {string} Transaction type
    pub fn r_transaction_type(&self) -> String {
        match &self.0 {
            TransactionNative::Deploy(..) => "deploy".to_string(),
            TransactionNative::Execute(..) => "execute".to_string(),
            TransactionNative::Fee(..) => "fee".to_string(),
        }
    }
}

impl From<RTransaction> for TransactionNative {
    fn from(transaction: RTransaction) -> Self {
        transaction.0
    }
}

impl From<TransactionNative> for RTransaction {
    fn from(transaction: TransactionNative) -> Self {
        Self(transaction)
    }
}

impl FromStr for RTransaction {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(Self(
            TransactionNative::from_str(s).map_err(|e| e.to_string())?,
        ))
    }
}
