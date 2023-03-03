// swiftlint:disable all
//
// Created by msyafiqq on 08/07/20.
// Copyright (c) 2020 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

public enum V1WidgetFactory {
    public static func createIconText(icon attachment: NSTextAttachment?, text: String, attributes attrs: [NSAttributedString.Key : Any]? = nil, space: String = "  ", isLeftPosition: Bool = true) -> NSAttributedString {
        let attributes = ([
            NSAttributedString.Key.foregroundColor: UIColor.Genie.accentSecondary,
            NSAttributedString.Key.font: FontHelper.DMSans.bold.font(16),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]).merging(attrs ?? [:]) {
            (_, new) in new
        }
        return createIconTextRaw(icon: attachment, text: text, attributes: attributes, space: space, isLeftPosition: isLeftPosition)
    }

    public static func createIconTextRaw(icon attachment: NSTextAttachment?, text: String, attributes attrs: [NSAttributedString.Key : Any]? = nil, space: String = "  ", isLeftPosition: Bool = true) -> NSAttributedString {
        let imageText: NSAttributedString? = attachment?.image == nil ? nil : NSMutableAttributedString(attachment: attachment!)
        let urlText = NSMutableAttributedString(
                string: "\(text)",
                attributes: attrs
        )

        let fullText = NSMutableAttributedString()
        if isLeftPosition {
            if let imageText = imageText {
                fullText.append(imageText)
                fullText.append(space)
            }
        }
        fullText.append(urlText)
        if !isLeftPosition {
            if let imageText = imageText {
                fullText.append(space)
                fullText.append(imageText)
            }
        }
        return fullText
    }
}

extension UIButton {
    func makeBottomRightShadow(of color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
    }
}
// swiftlint:enable all
