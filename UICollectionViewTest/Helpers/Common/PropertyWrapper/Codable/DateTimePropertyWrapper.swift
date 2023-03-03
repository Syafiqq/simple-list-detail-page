//
// Created by iosdev on 25/02/21.
// Copyright (c) 2021 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import SwiftDate
import CodableWrappers

struct StringDateTimeToDateStaticCoder: StaticCoder {
    static func decode(from decoder: Decoder) throws -> Date? {
        guard let dateString = try? String(from: decoder) else {
            return nil
        }
        return DateFormatter.yyyyMMdd_HHmmss.date(from: dateString)
    }

    static func encode(value: Date?, to encoder: Encoder) throws {
        guard let date = value else {
            return
        }

        try DateFormatter.yyyyMMdd_HHmmss.string(from: date).encode(to: encoder)
    }
}

// swiftlint:disable:next type_name
public struct StringDateTimeFromServerToDateStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Date? {
        let value = try String(from: decoder)
        return DateFormatter.yyyyMMdd_HHmmss_server.date(from: value)
    }

    public static func encode(value: Date?, to encoder: Encoder) throws {
        guard let date = value else {
            return
        }
        try DateFormatter.yyyyMMdd_HHmmss_server.string(from: date).encode(to: encoder)
    }
}

public struct StringDateFromServerToDateStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Date? {
        let value = try String(from: decoder)
        return DateFormatter.geniebookServerToDate.date(from: value)
    }

    public static func encode(value: Date?, to encoder: Encoder) throws {
        guard let date = value else {
            return
        }
        try DateFormatter.geniebookServerToDate.string(from: date).encode(to: encoder)
    }
}

// swiftlint:disable:next type_name
public struct StringOrIntSecondFromServerToDateStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Date? {
        var value = try? TimeInterval(from: decoder)
        if value == nil,
           let valueString = try? String(from: decoder),
           let valueProcessed = TimeInterval(valueString) {
            value = valueProcessed
        }

        guard let finalValue = value else {
            return nil
        }
        return Date(seconds: finalValue, region: DateHelper.serverRegion)
    }

    public static func encode(value: Date?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }
        try "\(Int64(DateInRegion(value, region: DateHelper.serverRegion).timeIntervalSince1970))"
                .encode(to: encoder)
    }
}

// swiftlint:disable:next type_name
public struct StringOrIntMillisecondFromServerToDateStaticCoder: StaticCoder {
    public static func decode(from decoder: Decoder) throws -> Date? {
        var value = try? TimeInterval(from: decoder)
        if value == nil,
           let valueString = try? String(from: decoder),
           let valueProcessed = TimeInterval(valueString) {
            value = valueProcessed
        }

        guard let finalValue = value else {
            return nil
        }
        return Date(milliseconds: Int(finalValue), region: DateHelper.serverRegion)
    }

    public static func encode(value: Date?, to encoder: Encoder) throws {
        guard let value = value else {
            return
        }
        try "\((DateInRegion(value, region: DateHelper.serverRegion).timeIntervalSince1970 * 1000))"
                .encode(to: encoder)
    }
}
