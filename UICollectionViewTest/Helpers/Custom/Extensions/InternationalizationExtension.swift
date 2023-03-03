// swiftlint:disable all
//
// Copyright (c) 2017 Mario Negro Martín
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import LanguageManager_iOS

private let kSupportedImplementedLanguages: [String] = ["en", "vi", "id", "zh-Hans"]
private let kSupportedDefaultLanguages: [String] = ["en", "vi", "id"]

// MARK: Localizable
public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return self.localiz()
    }
}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }

    @IBInspectable public var xibLocUpperKey: String? {
        get { return nil }
        set(key) {
            setTitle((key?.localized)?.uppercased(), for: .normal)
        }
    }

    @IBInspectable public var xibSemanticContentAttribute: String? {
        get { return nil }
        set(key) {
            if let typeOfSemnatic = key,typeOfSemnatic == "left" {
                self.semanticContentAttribute = .forceLeftToRight
            }
        }
    }

    @IBInspectable public var xibLocAttributeKey: String? {
        get { return nil }
        set(key) {
            if let str = key {
                let attributedString = NSMutableAttributedString( attributedString: NSAttributedString(string: (str.localized))  )
                attributedString.addAttributes(
                    [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                    range: NSRange.init(location: 0, length: attributedString.length)
                )
                self.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UITextView: XIBLocalizable{
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

//// MARK: Special protocol to localize multiple backButton's
//public protocol XIBBackButton{
//    var xibBackButtonLocKeys: String? { get set }
//}
//
//extension UINavigationItem: XIBBackButton {
//    @IBInspectable public var xibBackButtonLocKeys: String? {
//        get { return nil }
//        set(key) {
//
//        }
//    }
//}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var xibLocKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var xibLocKeys: String? {
        get { return nil }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}

// MARK: Special protocol to localize UISearchBar's placeholder
public protocol UISearchBarXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UISearchBar: UISearchBarXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get {return nil}
        set(key){
            placeholder = key?.localized
        }
    }

    @IBInspectable public var xibCancelLocKey: String? {
        get {return nil}
        set(key){
            if let str = key {
                setValue(str.localized, forKey: "cancelButtonText")
            }
        }
    }
}

struct LocalizationHelper {
    static func initializeLocalization(previousLang: Languages? = nil) {
        var language = previousLang ?? LanguageManager.shared.deviceLanguage ?? .en
        if !kSupportedDefaultLanguages.contains(language.rawValue) {
            language = .en
        }

        LanguageManager.shared.defaultLanguage = language
    }

    static func ensureNotChineseLanguageApplied() {
        guard isChinese() else {
            return
        }
        var language = LanguageManager.shared.defaultLanguage
        if let tempLanguageString = UserDefaults.standard.object(forKey: "i18n_temp_lang") as? String,
           let tempLanguage = Languages(rawValue: tempLanguageString) {
            UserDefaults.standard.removeObject(forKey: "i18n_temp_lang")
            language = tempLanguage
        }
        do {
            try Self.changeLanguage(to: language)
        } catch {
        }
    }

    static func isVietnamese() -> Bool {
        LocalizationHelper.currentLanguage == Languages.vi
    }

    static func isChinese() -> Bool {
        LocalizationHelper.currentLanguage == Languages.zhHK
    }

    static func changeLanguage(to language: Languages) throws {
        guard kSupportedImplementedLanguages.contains(language.rawValue) else {
            return
        }

        try LanguageManager.shared.setLanguage(language: language)
    }

    static var currentLanguage: Languages? {
        get {
            currentLanguageOrNil()
        }
    }

    static var currentLocale: Locale {
        get {
            guard let currentLanguage = LocalizationHelper.currentLanguage else {
                return Locale.current
            }
            return Locale(identifier: currentLanguage.rawValue)
        }
    }

    static func initializeIfNotExist() {
        if UserDefaults.standard.object(forKey: "LanguageManagerSelectedLanguage") == nil ||
           UserDefaults.standard.object(forKey: "LanguageManagerDefaultLanguage") == nil {
            LocalizationHelper.initializeLocalization()
        }
    }

    static func currentLanguageOrNil() -> Languages? {
        if UserDefaults.standard.object(forKey: "LanguageManagerSelectedLanguage") == nil {
            return nil
        } else {
            return LanguageManager.shared.currentLanguage
        }
    }
}
// swiftlint:enable all
