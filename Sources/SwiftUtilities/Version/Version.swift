//
//  Version.swift
//
//
//  Created by Kanta Oikawa on 2024/05/16.
//

import Foundation
import RegexBuilder

public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int?

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

extension Version: Equatable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.safePatch == rhs.safePatch
    }
}

extension Version: Comparable {
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
