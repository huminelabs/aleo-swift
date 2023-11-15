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
            path: "AleoCore.xcframework"
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

