// swift-tools-version: 5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "llama-cpp-swift",
    platforms: [.iOS(.v13), .macOS(.v10_13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Llama", targets: ["Llama"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Llama",
            dependencies: ["CLlama"]
        ),
        .target(
            name: "CLlama",
            sources: ["ggml.c", "llama.cpp"],
            publicHeadersPath: "headers",
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
