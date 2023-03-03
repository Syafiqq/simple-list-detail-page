// swiftlint:disable all
//
// Created by engineering on 6/7/23.
//

import Foundation

enum StudentError: RuntimeError {
    case notPremiumSubscription

    var message: String {
        switch self {
        case .notPremiumSubscription: return "Not Premium subscription"
        }
    }

    var internalError: Error? {
        nil
    }
}

enum ConversionError: RuntimeError {
    case failedToConvertData

    var message: String {
        switch self {
        case .failedToConvertData: return "Failed to convert data"
        }
    }

    var internalError: Error? {
        nil
    }
}
// swiftlint:enable all
