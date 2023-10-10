// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "cotton-vapor",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.83.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
// MARK: backend app
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
            ],
            resources: [
                .copy("Resources/Certs/localhost+1-key.pem"),
                .copy("Resources/Certs/localhost+1.pem")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
// MARK: plugins
        .plugin(name: "CopySSLCerts",
                capability: .command(intent: .custom(verb: "copy-ssl-certificates", description: "Copy SSL certificates resource to allow app executable find them"), permissions: [])),
        .plugin(name: "SwiftLintStep",
                capability: .command(intent: .sourceCodeFormatting(), permissions: [.writeToPackageDirectory(reason: "Linter formatting")])),
// MARK: app unit tests
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
        ])
    ]
)
