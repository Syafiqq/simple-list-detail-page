//
// Created by engineering on 17/5/22.
// Copyright (c) 2022 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation

extension Presentation {
    enum OneTimeDataFetcherUiState: Int {
        case initial = 0
        case loading = 1
        case failed = 2
        case success = 3
        case completed = 4
    }

    enum OneTimeDataFetcherUiStateV1: Int {
        case initial = 0
        case loading = 1
        case failed = 2
        case success = 3
        case completed = 4
        case blocked = 5
    }
}
