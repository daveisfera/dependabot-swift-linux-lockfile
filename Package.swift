// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LinuxLockfileRepro",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "LinuxLockfileRepro", targets: ["LinuxLockfileRepro"]),
    ],
    dependencies: [
        .package(path: "Packages/HostConditional"),
        // Remote pin so a lockfile exists on Apple platforms. Dependabot
        // updating this on Linux is enough to rewrite Package.resolved.
        .package(url: "https://github.com/apple/swift-log.git", from: "1.14.0"),
    ],
    targets: [
        .target(
            name: "LinuxLockfileRepro",
            dependencies: [
                "HostConditional",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
    ]
)
