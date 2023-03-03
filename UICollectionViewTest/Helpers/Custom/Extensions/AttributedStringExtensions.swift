// swiftlint:disable all
//
//  AttributedStringExtensions.swift
//  Geniebook
//
//  Created by adrian on 29/11/18.
//  Copyright © 2018 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func append(_ text: String, attributes: [NSAttributedString.Key : Any]? = nil) {
        self.append(NSMutableAttributedString(string: text, attributes: attributes))
    }
}
// swiftlint:enable all
