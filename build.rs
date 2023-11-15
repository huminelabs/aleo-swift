use std::path::PathBuf;

fn main() {
    let out_dir = PathBuf::from("./generated");
    let bridges = vec![
        "src/types/field.rs",
        "src/types/native.rs",
        "src/account/address.rs",
        "src/account/private_key_ciphertext.rs",
        "src/account/private_key.rs",
        "src/account/signature.rs",
        "src/account/view_key.rs",
        "src/record/record_ciphertext.rs",
        "src/record/record_plaintext.rs",
        "src/programs/proving_key.rs",
        "src/programs/verifying_key.rs",
        "src/programs/transaction.rs",
        "src/programs/key_pair.rs",
        "src/programs/program.rs",
        "src/programs/manager/program_manager.rs",
        "src/programs/manager/macros.rs",
    ];

    for path in &bridges {
        println!("cargo:rerun-if-changed={}", path);
    }

    swift_bridge_build::parse_bridges(bridges)
        .write_all_concatenated(out_dir, env!("CARGO_PKG_NAME"));
}
