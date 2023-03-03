//
// Created by iosdev on 27/08/21.
// Copyright (c) 2021 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import CodableWrappers

public struct StringOrIntToIntStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Int? {
        var value = try? Int(from: decoder)
        if value == nil,
           let valueString = try? String(from: decoder),
           let valueProcessed = Int(valueString) {
            value = valueProcessed
        }

        guard let finalValue = value else {
            return nil
        }
        return finalValue
    }

    public static func encode(value: Int?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }
        try value.encode(to: encoder)
    }
}
