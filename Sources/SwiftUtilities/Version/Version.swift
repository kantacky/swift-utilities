//
//  Version.swift
//
//
//  Created by Kanta Oikawa on 2024/05/16.
//

import Foundation
import RegexBuilder

/// A version according to the semantic versioning specification.
///
/// A package version consists of three integers separated by periods, for example `1.0.0`. It must conform to the semantic versioning standard in order to ensure
/// that your package behaves in a predictable manner once developers update their
/// package dependency to a newer version. To achieve predictability, the semantic versioning specification proposes a set of rules and
/// requirements that dictate how version numbers are assigned and incremented. To learn more about the semantic versioning specification, visit
/// [Semantic Versioning 2.0.0](https://semver.org).
///
/// - term The major version: The first digit of a version, or _major version_,
/// signifies breaking changes to the API that require updates to existing
/// clients. For example, the semantic versioning specification considers
/// renaming an existing type, removing a method, or changing a method's
/// signature breaking changes. This also includes any backward-incompatible bug
/// fixes or behavioral changes of the existing API.
///
/// - term The minor version:
/// Update the second digit of a version, or _minor version_, if you add
/// functionality in a backward-compatible manner. For example, the semantic
/// versioning specification considers adding a new method or type without
/// changing any other API to be backward-compatible.
///
/// - term The patch version:
/// Increase the third digit of a version, or _patch version_, if you're making
/// a backward-compatible bug fix. This allows clients to benefit from bugfixes
/// to your package without incurring any maintenance burden.
public struct Version {

    /// The major version according to the semantic versioning standard.
    public let major: Int

    /// The minor version according to the semantic versioning standard.
    public let minor: Int

    /// The minor version according to the semantic versioning standard.
    public let patch: Int?

    /// Initializes a version struct with the provided components of a semantic version.
    /// - Parameters:
    ///   - major: The major version number.
    ///   - minor: The minor version number.
    ///   - patch: The patch version number.
    ///
    /// - Precondition: `major >= 0 && minor >= 0 && patch >= 0`.
    public init(
        _ major: Int,
        _ minor: Int,
        _ patch: Int? = nil
    ) throws {
        if major < 0 {
            throw VersionError.majorValidationError
        }
        if minor < 0 {
            throw VersionError.minorValidationError
        }
        if let patch,
           patch < 0 {
            throw VersionError.patchValidationError
        }
        if major == 0 && minor == 0 && (patch == nil || patch == 0) {
            throw VersionError.versionValidationError
        }
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public init(string: String) throws {
        let format2 = Regex {
            Capture { OneOrMore { .digit } }
            "."
            Capture { OneOrMore { .digit } }
        }
        let format3 = Regex {
            Capture { OneOrMore { .digit } }
            "."
            Capture { OneOrMore { .digit } }
            "."
            Capture { OneOrMore { .digit } }
        }
        if let match2 = string.wholeMatch(of: format2) {
            guard
                let major = Int(match2.1),
                let minor = Int(match2.2)
            else {
                throw VersionError.formatError
            }
            self = try Self.init(major, minor)
            return
        }
        if let match3 = string.wholeMatch(of: format3) {
            guard
                let major = Int(match3.1),
                let minor = Int(match3.2),
                let patch = Int(match3.3)
            else {
                throw VersionError.formatError
            }
            self = try Self.init(major, minor, patch)
            return
        }
        throw VersionError.formatError
    }
}

extension Version: Comparable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`, `a ==
    /// b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    ///
    /// - Returns: A boolean value indicating the result of the equality test.
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.safePatch == rhs.safePatch
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        if (lhs.major != rhs.major) {
            return lhs.major < rhs.major
        }
        if (lhs.minor != rhs.minor) {
            return lhs.minor < rhs.minor
        }
        if (lhs.safePatch != rhs.safePatch) {
            return lhs.safePatch < rhs.safePatch
        }
        return false
    }
}

public extension Version {
    var safePatch: Int {
        patch ?? 0
    }
}

public extension Version {
    var string: String {
        if let patch {
            return "\(major).\(minor).\(patch)"
        }
        return "\(major).\(minor)"
    }
}
