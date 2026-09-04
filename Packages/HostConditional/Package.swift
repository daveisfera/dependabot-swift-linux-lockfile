// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "HostConditional",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "HostConditional", targets: ["HostConditional"]),
    ],
    targets: [
        .target(name: "HostConditional"),
    ]
)

// Same pattern as skip-model: the extra package is only added when the
// *resolving host* cannot import Combine (Linux), not via a target condition.
#if !canImport(Combine)
package.dependencies += [
    .package(url: "https://github.com/OpenSwiftUIProject/OpenCombine.git", from: "0.15.1"),
]
package.targets[0].dependencies += [
    .product(name: "OpenCombine", package: "OpenCombine"),
]
#endif
