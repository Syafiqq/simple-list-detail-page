//
//  FloatPropertyWrapper.swift
//  Geniebook
//
//  Created by DanYan on 08/09/22.
//  Copyright © 2022 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import CodableWrappers

public struct StringOrFloatToFloatStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Float? {
        var value = try? Float(from: decoder)

        if value == nil,
           let valueString = try? String(from: decoder),
           let valueProcessed = Float(valueString) {
            value = valueProcessed
        }

        guard let finalValue = value else {
            return nil
        }

        return finalValue
    }

    public static func encode(value: Float?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }
        try value.encode(to: encoder)
    }
}
