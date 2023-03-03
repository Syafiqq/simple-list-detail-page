// swiftlint:disable file_types_order
// Have to do this switching position won't resolve the problem
//
// Created by iosdev on 17/07/21.
// Copyright (c) 2021 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import CodableWrappers

struct StringOrIntToEnumStringStaticCoder<T>: StaticCoder
        where T: RawRepresentable, T: Codable, T.RawValue == String {
    static func decode(from decoder: Decoder) throws -> T? {
        var value = try? String(from: decoder)
        if value == nil,
           let intValue = try? Int(from: decoder) {
            value = "\(intValue)"
        }
        if let stringValue = value {
            return T(rawValue: stringValue)
        } else {
            return nil
        }
    }

    static func encode(value: T?, to encoder: Encoder) throws {
        try value?.rawValue.encode(to: encoder)
    }
}

struct StringOrIntToEnumIntStaticCoder<T>: StaticCoder
        where T: RawRepresentable, T: Codable, T.RawValue == Int {
    static func decode(from decoder: Decoder) throws -> T? {
        var value = (try? String(from: decoder))?.toInt()
        if value == nil,
           let intValue = try? Int(from: decoder) {
            value = intValue
        }
        if let intValue = value {
            return T(rawValue: intValue)
        } else {
            return nil
        }
    }

    static func encode(value: T?, to encoder: Encoder) throws {
        try value?.rawValue.encode(to: encoder)
    }
}
// swiftlint:enable file_types_order

extension String {
    func toInt(`default`: Int? = nil) -> Int? {
        Int(self) ?? `default`
    }
}
