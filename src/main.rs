use std::collections::HashMap;
use std::path::PathBuf;
use swift_bridge_build::{ApplePlatform, CreatePackageConfig};
fn main() {
    swift_bridge_build::create_package(CreatePackageConfig {
        swift_tools_version: "5.9.0".to_string(),
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
        platforms_list: vec![
            ".iOS(.v17)".to_string(),
            ".macOS(.v14)".to_string(),
            ".watchOS(.v10)".to_string(),
        ],
        dependencies: vec![
            r#".package(url: "https://github.com/nafehshoaib/SwiftCloud.git", branch: "main")"#.to_string(),
            r#".package(url: "https://github.com/jessesquires/Foil.git", .upToNextMajor(from: "4.0.1"))"#.to_string(),
        ],
        dependency_packages: vec!["SwiftCloud".to_string(), "Foil".to_string()],
    });
}
