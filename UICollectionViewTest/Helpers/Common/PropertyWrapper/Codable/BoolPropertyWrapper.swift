// swiftlint:disable file_types_order
// Created by iosdev on 25/02/21.
// Copyright (c) 2021 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import CodableWrappers

struct StringOrIntOrBoolToBoolStaticCoder: StaticCoder {
    static func decode(from decoder: Decoder) throws -> Bool {
        var value = try? String(from: decoder)
        if value == nil,
           let intValue = try? Int(from: decoder) {
            value = "\(intValue)"
        }
        if value == nil,
           let boolValue = try? Bool?(from: decoder) {
            value = boolValue ? "1" : "0"
        }

        if value == nil {
            return try Bool(from: decoder)
        } else {
            return value == "1"
        }
    }

    static func encode(value: Bool, to encoder: Encoder) throws {
        let value = value ? "1" : "0"
        try value.encode(to: encoder)
    }
}

struct BoolDefaultTrueProvider: FallbackValueProvider {
    static var defaultValue: Bool { true }
}
// swiftlint:enable file_types_order
