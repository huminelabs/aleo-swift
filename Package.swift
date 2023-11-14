// swift-tools-version:5.9.0
import PackageDescription
let package = Package(
    name: "Aleo",
    platforms: [.iOS(.v17), .macOS(.v14), .watchOS(.v10)],
    products: [
        .library(
            name: "Aleo",
            targets: ["Aleo"]),
    ],
    dependencies: [.package(url: "https://github.com/nafehshoaib/SwiftCloud.git", branch: "main")],
    targets: [
        .binaryTarget(
            name: "AleoCore",
            url: "https://github.com/huminelabs/aleo-swift/releases/download/v0.1-alpha/AleoCore.xcframework.zip",
            checksum: "e40d9f5a38980daa176737b3b67575eb1d850f0159783c95ff2294df03e69b19"
        ),
        .target(
            name: "Aleo",
            dependencies: ["AleoCore", "SwiftCloud"]),
        .testTarget(
            name: "AleoTests",
            dependencies: ["Aleo", "AleoCore", "SwiftCloud"]
        )
    ]
)
