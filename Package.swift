// swift-tools-version:6.3
import PackageDescription

let package = Package(
  name: "elementary-web-app",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(url: "https://github.com/elementary-swift/elementary-ui.git", from: "0.4.1")
  ],
  targets: [
    .executableTarget(
      name: "WebApp",
      dependencies: [
        .product(name: "ElementaryUI", package: "elementary-ui")
      ],
      swiftSettings: [
        .swiftLanguageMode(.v5)
      ],
      linkerSettings: [
        .linkedLibrary("swiftUnicodeDataTables")
      ],
    )
  ]
)
