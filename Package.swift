// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ExpenseTrackerCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ExpenseTrackerCore",
            targets: ["ExpenseTrackerCore"]
        )
    ],
    targets: [
        .target(
            name: "ExpenseTrackerCore"
        ),
        .testTarget(
            name: "ExpenseTrackerCoreTests",
            dependencies: ["ExpenseTrackerCore"]
        )
    ]
)
