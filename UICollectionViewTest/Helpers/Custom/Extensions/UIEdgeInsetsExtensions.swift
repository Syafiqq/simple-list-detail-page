//
//  UIEdgeInsetsExtensions.swift
//  Geniebook
//
//  Created by DanYan on 31/03/22.
//  Copyright © 2022 Geniebook Pte. Ltd. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
}
