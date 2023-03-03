// swiftlint:disable all
//
//  Constants.swift
//  Geniebook
//
//  Created by adrian on 7/2/18.
//  Copyright © 2018 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

struct Constants {
    struct Skeleton {
        static let skeletonId = -10
        static let skeletonGradientBackgroundLight = SkeletonGradient(baseColor: .skeletonDefault)
        static let skeletonGradientBackgroundPrimary = SkeletonGradient(baseColor: UIColor(netHex: 0xd7eef9), secondaryColor: UIColor(netHex: 0xc5e7f7))
        static let skeletonGradientWhite = SkeletonGradient(baseColor: .skeletonDefault)
    }
}
// swiftlint:enable all
