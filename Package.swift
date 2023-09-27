// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "FactoryMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "FactoryMacro",
            targets: ["FactoryMacro"]
        ),
        .executable(
            name: "FactoryMacroClient",
            targets: ["FactoryMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMinor(from: "2.2.0")),
    ],
    targets: [
        .macro(
            name: "FactoryMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "FactoryMacro", dependencies: ["FactoryMacroMacros", "Factory"]),
        .executableTarget(name: "FactoryMacroClient", dependencies: ["FactoryMacro", "Factory"]),
        .testTarget(
            name: "FactoryMacroTests",
            dependencies: [
                "FactoryMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(.enableExperimentalFeature("StrictConcurrency"))
    target.swiftSettings = settings
}
