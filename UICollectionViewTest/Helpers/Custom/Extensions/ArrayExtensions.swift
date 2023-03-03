// swiftlint:disable all
//
//  ArrayExtensions.swift
//  Geniebook
//
//  Created by msyafiqq on 27/07/20.
//  Copyright © 2020 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safeIndex index: Int) -> Element? {
        if isSafe(index: index) {
            return self[index]
        } else {
            return nil
        }
    }
    
    @inlinable func isSafe(index: Int) -> Bool {
        index >= 0 && index < endIndex
    }

    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

public extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
// swiftlint:enable all
