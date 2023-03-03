//
// Created by Engineering  on 08/04/22.
// Copyright (c) 2022 beautyfulminds. All rights reserved.
//

import Foundation

extension Presentation {
    struct UiStateModel<T, S> where S: RawRepresentable {
        var data: T?
        var error: Error?
        var state: S
    }

    struct UiListStateModel<T, S> where S: RawRepresentable {
        var data: T?
        var index: [Int]
        var error: Error?
        var state: S
    }

    struct UiListStateModelV1<T, S> where S: RawRepresentable {
        var sequence: Int
        var data: T?
        var index: [Int]
        var error: Error?
        var state: S
    }
}
