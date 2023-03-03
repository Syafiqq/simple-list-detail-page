//
// Created by iosdev on 25/02/21.
// Copyright (c) 2021 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import CodableWrappers

struct StringOrIntToStringStaticCoder: StaticCoder {
    static func decode(from decoder: Decoder) throws -> String? {
        var value = try? String(from: decoder)
        if value == nil,
           let intValue = try? Int(from: decoder) {
            value = "\(intValue)"
        }

        return value
    }

    static func encode(value: String?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }

        try value.encode(to: encoder)
    }
}
