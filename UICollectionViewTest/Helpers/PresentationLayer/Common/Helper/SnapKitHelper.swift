//
// Created by engineering on 13/5/22.
// Copyright (c) 2022 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import SnapKit

extension ConstraintMakerFinalizable {
    @discardableResult
    func debugLabeled(_ label: String) -> ConstraintMakerFinalizable {
        #if DEBUG
        return labeled(label)
        #endif
        return self
    }
}
