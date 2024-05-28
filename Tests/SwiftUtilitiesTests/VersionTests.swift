//
//  VersionTests.swift
//
//
//  Created by Kanta Oikawa on 2024/05/16.
//

import SwiftUtilities
import XCTest

final class VersionTests: XCTestCase {
    func testInitializeWithNumbers2() async throws {
        let major = 1
        let minor = 2
        let version = try Version(major, minor)
        XCTAssertEqual(version.major, major)
        XCTAssertEqual(version.minor, minor)
        XCTAssertNil(version.patch)
    }

    func testInitializeWithString2() async throws {
        let major = 1
        let minor = 3
        let versionString = "\(major).\(minor)"
        let version = try Version(string: versionString)
        XCTAssertEqual(version.major, major)
        XCTAssertEqual(version.minor, minor)
        XCTAssertNil(version.patch)
    }

    func testInitializeWithNumbers3() async throws {
        let major = 1
        let minor = 3
        let patch = 2
        let version = try Version(major, minor, patch)
        XCTAssertEqual(version.major, major)
        XCTAssertEqual(version.minor, minor)
        XCTAssertEqual(version.patch, patch)
    }

    func testInitializeWithString3() async throws {
        let major = 1
        let minor = 3
        let patch = 2
        let versionString = "\(major).\(minor).\(patch)"
        let version = try Version(string: versionString)
        XCTAssertEqual(version.major, major)
        XCTAssertEqual(version.minor, minor)
        XCTAssertEqual(version.patch, patch)
    }

    func testInitializeFailureWithMajorValidation() async throws {
        let expected = VersionError.majorValidationError.localizedDescription
        XCTAssertThrowsError(try Version(-1, 0), expected)
    }

    func testInitializeFailureWithMinorValidation() async throws {
        let expected = VersionError.minorValidationError.localizedDescription
        XCTAssertThrowsError(try Version(0, -1), expected)
    }

    func testInitializeFailureWithPatchValidation() async throws {
        let expected = VersionError.patchValidationError.localizedDescription
        XCTAssertThrowsError(try Version(0, 0, -1), expected)
    }

    func testInitializeFailureWithVersionValidation() async throws {
        let expected = VersionError.versionValidationError.localizedDescription
        XCTAssertThrowsError(try Version(0, 0, 0), expected)
    }

    func testInitializeFailureWithFormatError() async throws {
        let expected = VersionError.formatError.localizedDescription
        XCTAssertThrowsError(try Version(string: "1"), expected)
        XCTAssertThrowsError(try Version(string: "1.2.3.4"), expected)
    }

    func testEquals() async throws {
        let version1_0 = try Version(1, 0)
        let version1_0_0 = try Version(1, 0, 0)
        XCTAssertEqual(version1_0, version1_0_0)
    }

    func testCompare() async throws {
        let version1_0 = try Version(1, 0)
        let version1_0_1 = try Version(1, 0, 1)
        XCTAssertLessThan(version1_0, version1_0_1)
    }

    func testString2() async throws {
        let version1_2 = try Version(1, 2)
        let expected = "1.2"
        XCTAssertEqual(version1_2.string, expected)
    }

    func testString3() async throws {
        let version1_3_2 = try Version(1, 3, 2)
        let expected = "1.3.2"
        XCTAssertEqual(version1_3_2.string, expected)
    }
}
