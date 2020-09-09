// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Koinu",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "Koinu", targets: ["Koinu"]),
  ],
  targets: [
    .target(name: "Koinu", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)
