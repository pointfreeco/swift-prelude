#!/usr/bin/env swift

import Foundation

private struct PackageDescription: Decodable {
    let name: String
    let targets: [Target]
}

private struct Target: Decodable {
    let c99Name: String?
    let moduleType: String?
    let name: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case c99Name = "c99name"
        case moduleType = "module_type"
        case name
        case type
    }
}

private struct Options {
    var includeTests = false
    var selectedTargets = Set<String>()
    var jsonPath: String?
}

private func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("swiftinterfaces: \(message)\n".utf8))
    exit(1)
}

private var options = Options()
private var arguments = Array(CommandLine.arguments.dropFirst())

while !arguments.isEmpty {
    let argument = arguments.removeFirst()
    switch argument {
    case "--include-tests":
        options.includeTests = true
    case "--target":
        guard !arguments.isEmpty else { fail("--target requires a value") }
        options.selectedTargets.insert(arguments.removeFirst())
    default:
        guard !argument.hasPrefix("-") else { fail("unknown parser option: \(argument)") }
        guard options.jsonPath == nil else { fail("expected exactly one package-description JSON file") }
        options.jsonPath = argument
    }
}

guard let jsonPath = options.jsonPath else { fail("missing package-description JSON file") }

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
    let package = try JSONDecoder().decode(PackageDescription.self, from: data)
    let swiftTargets = package.targets.filter { target in
        target.moduleType == "SwiftTarget" && (options.includeTests || target.type != "test")
    }
    let availableNames = Set(swiftTargets.map(\.name))
    let unknownTargets = options.selectedTargets.subtracting(availableNames).sorted()

    guard unknownTargets.isEmpty else {
        fail("unknown or excluded Swift target(s): \(unknownTargets.joined(separator: ", "))")
    }

    let selected = swiftTargets
        .filter { options.selectedTargets.isEmpty || options.selectedTargets.contains($0.name) }
        .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }

    guard !selected.isEmpty else { fail("the package has no matching Swift targets") }

    for target in selected {
        guard let moduleName = target.c99Name, !moduleName.isEmpty else {
            fail("target \(target.name) does not have a Swift module name")
        }
        print("\(target.name)\t\(moduleName)\t\(target.type)\t\(package.name)")
    }
} catch {
    fail("could not decode package description: \(error)")
}
