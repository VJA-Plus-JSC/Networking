// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
      .iOS(.v13),
      .macOS(.v11)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            name: "Alamofire",
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.9.1"))
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [.product(name: "Alamofire", package: "Alamofire")]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
    ]
)
