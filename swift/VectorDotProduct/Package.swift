// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "VectorDotProduct",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "VectorDotProduct",
            targets: ["VectorDotProduct"])
    ],
    targets: [
        .executableTarget(
            name: "VectorDotProduct",
            path: ".",
            sources: ["main.swift"])
    ]
)