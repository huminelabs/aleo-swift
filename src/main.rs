use std::collections::HashMap;
use std::path::PathBuf;
use swift_bridge_build::{ApplePlatform, CreatePackageConfig};
fn main() {
    swift_bridge_build::create_package(CreatePackageConfig {
        bridge_dir: PathBuf::from("./generated"),
        paths: HashMap::from([
            (
                ApplePlatform::IOS,
                "./target/aarch64-apple-ios/debug/libaleo_swift.a".into(),
            ),
            (
                ApplePlatform::Simulator,
                "./target/universal-ios/debug/libaleo_swift.a".into(),
            ),
            (
                ApplePlatform::MacOS,
                "./target/universal-macos/debug/libaleo_swift.a".into(),
            ),
        ]),
        out_dir: PathBuf::from("./"),
        package_name: "Aleo".to_string(),
        xc_framework_name: "AleoCore".to_string(),
    });
}
