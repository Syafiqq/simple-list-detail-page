// swiftlint:disable all
//
//  FontHelper.swift
//  Geniebook
//
//  Created by adrian on 7/3/18.
//  Copyright © 2018 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FONTS
public class FontHelper {
    static func create(name font: String?, withSize size: CGFloat) -> UIFont {
        if let fontName = font,
           let font: UIFont = UIFont(name: fontName, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }

    public enum DMSans {
        case regular
        case medium
        case italic
        case mediumItalic
        case bold
        case boldItalic
    }

    public enum OpenSans {
        case regular
        case medium
        case italic
        case mediumItalic
        case bold
        case boldItalic
        case semiBold
        case semiBoldItalic
        case extraBold
        case extraBoldItalic
        case light
        case lightItalic
    }

    public enum SHSans: Int {
        case extraLight = 100
        case light = 200
        case normal = 300
        case regular = 400
        case medium = 500
        case bold = 700
        case heavy = 900
    }

    public enum BeVietnam: Int {
        // @formatter:off
        case thin             = 100
        case thinItalic       = 101
        case extraLight       = 200
        case extraLightItalic = 201
        case light            = 300
        case lightItalic      = 301
        case regular          = 400
        case italic           = 401
        case medium           = 500
        case mediumItalic     = 501
        case semiBold         = 600
        case semiBoldItalic   = 601
        case bold             = 700
        case boldItalic       = 701
        case extraBold        = 800
        case extraBoldItalic  = 801
        case black            = 900
        case blackItalic      = 901
        // @formatter:off
    }
}

public extension FontHelper.DMSans {
    func font(_ size: CGFloat, allowAppOverrides: Bool = true) -> UIFont {
        switch (self) {
        case .regular:         return FontHelper.OpenSans.regular.font(size, allowAppOverrides: allowAppOverrides)
        case .medium:          return FontHelper.OpenSans.medium.font(size, allowAppOverrides: allowAppOverrides)
        case .italic:          return FontHelper.OpenSans.italic.font(size, allowAppOverrides: allowAppOverrides)
        case .mediumItalic:    return FontHelper.OpenSans.mediumItalic.font(size, allowAppOverrides: allowAppOverrides)
        case .bold:            return FontHelper.OpenSans.bold.font(size, allowAppOverrides: allowAppOverrides)
        case .boldItalic:      return FontHelper.OpenSans.boldItalic.font(size, allowAppOverrides: allowAppOverrides)
        default:               return FontHelper.create(name: "null", withSize: size)
        }
    }
}

public extension FontHelper.OpenSans {
    func font(_ size: CGFloat, allowAppOverrides: Bool = true) -> UIFont {
        if allowAppOverrides {
            if LocalizationHelper.isVietnamese() {
                // @formatter:off
                switch (self) {
                case .regular               : return FontHelper.BeVietnam.regular.font(size, allowAppOverrides: false)
                case .medium                : return FontHelper.BeVietnam.medium.font(size, allowAppOverrides: false)
                case .italic                : return FontHelper.BeVietnam.italic.font(size, allowAppOverrides: false)
                case .mediumItalic          : return FontHelper.BeVietnam.mediumItalic.font(size, allowAppOverrides: false)
                case .bold                  : return FontHelper.BeVietnam.bold.font(size, allowAppOverrides: false)
                case .boldItalic            : return FontHelper.BeVietnam.boldItalic.font(size, allowAppOverrides: false)
                case .semiBold              : return FontHelper.BeVietnam.semiBold.font(size, allowAppOverrides: false)
                case .semiBoldItalic        : return FontHelper.BeVietnam.semiBoldItalic.font(size, allowAppOverrides: false)
                case .extraBold             : return FontHelper.BeVietnam.extraBold.font(size, allowAppOverrides: false)
                case .extraBoldItalic       : return FontHelper.BeVietnam.extraBoldItalic.font(size, allowAppOverrides: false)
                case .light                 : return FontHelper.BeVietnam.light.font(size, allowAppOverrides: false)
                case .lightItalic           : return FontHelper.BeVietnam.lightItalic.font(size, allowAppOverrides: false)
                default                     : return FontHelper.create(name: "null", withSize: size)
                // @formatter:on
                }
            } else {
                return font(size, allowAppOverrides: false)
            }
        } else {
            switch (self) {
            case .regular: return FontHelper.create(name: "OpenSans-Regular", withSize: size)
            case .medium: return FontHelper.create(name: "OpenSans-Medium", withSize: size)
            case .italic: return FontHelper.create(name: "OpenSans-Italic", withSize: size)
            case .mediumItalic: return FontHelper.create(name: "OpenSans-MediumItalic", withSize: size)
            case .bold: return FontHelper.create(name: "OpenSans-Bold", withSize: size)
            case .boldItalic: return FontHelper.create(name: "OpenSans-BoldItalic", withSize: size)
            case .semiBold: return FontHelper.create(name: "OpenSans-SemiBold", withSize: size)
            case .semiBoldItalic: return FontHelper.create(name: "OpenSans-SemiBoldItalic", withSize: size)
            case .extraBold: return FontHelper.create(name: "OpenSans-ExtraBold", withSize: size)
            case .extraBoldItalic: return FontHelper.create(name: "OpenSans-ExtraBoldItalic", withSize: size)
            case .light: return FontHelper.create(name: "OpenSans-Light", withSize: size)
            case .lightItalic: return FontHelper.create(name: "OpenSans-LightItalic", withSize: size)
            default: return FontHelper.create(name: "null", withSize: size)
            }
        }
    }
}

public extension FontHelper.SHSans {
    func font(_ size: CGFloat, allowAppOverrides: Bool = true) -> UIFont {
        switch (self) {
        case .extraLight:   return FontHelper.OpenSans.light.font(size, allowAppOverrides: allowAppOverrides)
        case .light:        return FontHelper.OpenSans.light.font(size, allowAppOverrides: allowAppOverrides)
        case .normal:       return FontHelper.OpenSans.regular.font(size, allowAppOverrides: allowAppOverrides)
        case .regular:      return FontHelper.OpenSans.regular.font(size, allowAppOverrides: allowAppOverrides)
        case .medium:       return FontHelper.OpenSans.medium.font(size, allowAppOverrides: allowAppOverrides)
        case .bold:         return FontHelper.OpenSans.bold.font(size, allowAppOverrides: allowAppOverrides)
        case .heavy:        return FontHelper.OpenSans.extraBold.font(size, allowAppOverrides: allowAppOverrides)
        default:            return FontHelper.create(name: "null", withSize: size)
        }
    }
}

public extension FontHelper.BeVietnam {
    func font(_ size: CGFloat, allowAppOverrides: Bool = true) -> UIFont {
        // @formatter:off
        switch (self) {
        case .thin             : return FontHelper.create(name: "BeVietnamPro-Thin", withSize: size)
        case .thinItalic       : return FontHelper.create(name: "BeVietnamPro-ThinItalic", withSize: size)
        case .extraLight       : return FontHelper.create(name: "BeVietnamPro-ExtraLight", withSize: size)
        case .extraLightItalic : return FontHelper.create(name: "BeVietnamPro-ExtraLightItalic", withSize: size)
        case .light            : return FontHelper.create(name: "BeVietnamPro-Light", withSize: size)
        case .lightItalic      : return FontHelper.create(name: "BeVietnamPro-LightItalic", withSize: size)
        case .regular          : return FontHelper.create(name: "BeVietnamPro-Regular", withSize: size)
        case .italic           : return FontHelper.create(name: "BeVietnamPro-Italic", withSize: size)
        case .medium           : return FontHelper.create(name: "BeVietnamPro-Medium", withSize: size)
        case .mediumItalic     : return FontHelper.create(name: "BeVietnamPro-MediumItalic", withSize: size)
        case .semiBold         : return FontHelper.create(name: "BeVietnamPro-SemiBold", withSize: size)
        case .semiBoldItalic   : return FontHelper.create(name: "BeVietnamPro-SemiBoldItalic", withSize: size)
        case .bold             : return FontHelper.create(name: "BeVietnamPro-Bold", withSize: size)
        case .boldItalic       : return FontHelper.create(name: "BeVietnamPro-BoldItalic", withSize: size)
        case .extraBold        : return FontHelper.create(name: "BeVietnamPro-ExtraBold", withSize: size)
        case .extraBoldItalic  : return FontHelper.create(name: "BeVietnamPro-ExtraBoldItalic", withSize: size)
        case .black            : return FontHelper.create(name: "BeVietnamPro-Black", withSize: size)
        case .blackItalic      : return FontHelper.create(name: "BeVietnamPro-BlackItalic", withSize: size)
        default                : return FontHelper.create(name: "null", withSize: size)
        // @formatter:on
        }
    }
}
// swiftlint:enable all
