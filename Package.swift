// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "wordAppBE",
    products: [
        .library(name: "wordAppBE", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
		.package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
		.package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc"),
		.package(url: "https://github.com/vapor/crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor", "Authentication", "Crypto"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

