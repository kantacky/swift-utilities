//
//  VersionError.swift
//
//
//  Created by Kanta Oikawa on 2024/05/16.
//

import Foundation

public enum VersionError: LocalizedError {
    case versionValidationError
    case majorValidationError
    case minorValidationError
    case patchValidationError
    case formatError

    public var errorDescription: String? {
        switch self {
        case .versionValidationError:
            return "Version must be 0 or positive."

        case .majorValidationError:
            return "Major version must be 0 or a positive integer."

        case .minorValidationError:
            return "Minor version must be 0 or a positive integer."

        case .patchValidationError:
            return "Patch version must be 0 or a positive integer."

        case .formatError:
            return "Invalid string format."
        }
    }
}
