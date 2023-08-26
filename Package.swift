// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "llama-cpp-swift",
    platforms: [.iOS(.v13), .macOS(.v10_13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Llama", targets: ["Llama"]),
        .library(name: "CLlama", targets: ["CLlama"]),
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
            exclude: ["ggml-metal.metal"],
            sources: ["ggml.c", "llama.cpp"],
            publicHeadersPath: "spm-headers",
            cSettings: [.unsafeFlags(["-Wno-shorten-64-to-32"]), .define("GGML_USE_ACCELERATE")],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
