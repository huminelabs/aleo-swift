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
	dependencies: [.package(url: "https://github.com/nafehshoaib/SwiftCloud.git", branch: "main"), .package(url: "https://github.com/jessesquires/Foil.git", .upToNextMajor(from: "4.0.1"))],
	targets: [
		.binaryTarget(
			name: "AleoCore",
			path: "AleoCore.xcframework"
		),
		.target(
			name: "Aleo",
			dependencies: ["AleoCore", "SwiftCloud", "Foil"]
        ),
        .testTarget(
            name: "AleoTests",
            dependencies: ["Aleo", "AleoCore", "SwiftCloud", "Foil"]
        )
	]
)
	