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
            url: "https://github.com/huminelabs/aleo-swift/releases/download/v0.2-alpha/AleoCore.xcframework.zip",
            checksum: "4611c09d1c726d595fbca6151da3285597da2965771fe92242cb515a21006178"
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
