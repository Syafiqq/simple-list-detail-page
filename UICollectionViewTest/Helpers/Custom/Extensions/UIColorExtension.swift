// swiftlint:disable all
//
// Created by msyafiqq on 08/07/20.
// Copyright (c) 2020 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(alpha: 255, red: red, green: green, blue: blue)
    }

    convenience init(alpha: Int, red: Int, green: Int, blue: Int) {
        assert(alpha >= 0 && alpha <= 255, "Invalid alpha component")
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }

    convenience init(argbHex hex :Int) {
        self.init(alpha: (hex >> 24) & 0xff, red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    struct Genie {
        public static let primary = GBPNavy
        public static let accentSecondary = UIColor(netHex: 0xF7A440)
        public static let accentSecondaryDark = UIColor(netHex: 0xF7941E)
        public static let accentSecondaryLight = UIColor(netHex: 0xFCC412)
        public static let accentTernary = UIColor(netHex: 0x5148D1)
        public static let invertAccentTernary = UIColor(netHex: 0xD8D8D8)
        public static let textPrimary = UIColor(netHex: 0x156E94)
        public static let textPrimaryDark = UIColor(netHex: 0x333333)
        public static let textPrimaryDarkMedium = UIColor(netHex: 0x888888)
        public static let backgroundDark = textPrimaryDark
        public static let backgroundDark1 = UIColor(netHex: 0x222222)
        public static let backgroundLight = UIColor(netHex: 0xFCFDFF)
        public static let backgroundPrimary = UIColor(netHex: 0xF4FAFD)
        public static let backgroundPrimary1 = UIColor(netHex: 0xF4F7FC)
        public static let backgroundFieldDisabled = UIColor(netHex: 0xF8F8F8)
        public static let backgroundButtonDisabled = UIColor(netHex: 0xC2C2C2)
        public static let borderLight = UIColor(netHex: 0xB4B4B4)
        public static let borderDark = UIColor(netHex: 0x707070)
        public static let borderAccentTernary = UIColor(netHex: 0x817CE1)
        public static let borderAccentTernaryDisabled = UIColor(netHex: 0xC2BFEF)
        public static let titleTextTitlePrimary = UIColor(netHex: 0xF1F2F2)
        public static let buttonDisableLight = UIColor(netHex: 0xF5F5F5)
        public static let labelSubtitle = UIColor(netHex: 0x515151)
        public static let labelSubtitleVariant1 = borderDark
        public static let labelSubtitleVariant2 = UIColor(netHex: 0x8D8E92)
        public static let dropShadow = UIColor(argbHex: 0x29000000)
        public static let dropShadowLight = UIColor(argbHex: 0x124B8E29)
        public static let backgroundGrey = UIColor(netHex: 0xEDF1F8)
        public static let dangerVariant1 = UIColor(netHex: 0xDD6E6E)
        public static let backgroundDisabled = UIColor(netHex: 0xEFEFEF)
        public static let titleTextTitlePrimary1 = UIColor(netHex: 0xF1F2F3)
        public static let chatBoxBackground = UIColor(netHex: 0xF7F7F7)
        public static let chatBoxBorder = UIColor(netHex: 0xF0F0F0)
        public static let networkErrorBackground = UIColor(netHex: 0xFEE79C)
        public static let worksheetPrimary = GBPNavy
        public static let worksheetQuestionListText = UIColor(netHex: 0x110E3E)
        public static let worksheetQuestionListCorrect = UIColor(netHex: 0x76C48E)
        public static let worksheetQuestionListSubmitted = UIColor(netHex: 0xD6D3FF)
        public static let worksheetQuestionListPullDownBar = UIColor(netHex: 0xBCD6E1)
        public static let worksheetMCQRadioBackground = UIColor(netHex: 0x166F94)
        public static let genieAskFailedMessageIcon = UIColor(netHex: 0xED4444)
        public static let canvasBlack = UIColor(netHex: 0x000000)
        public static let canvasWhite = UIColor(netHex: 0xFFFFFF)
        public static let canvasOrange = UIColor(netHex: 0xFF9C16)
        public static let canvasGreen = UIColor(netHex: 0x54B87E)
        public static let canvasBlue = UIColor(netHex: 0x3B92F8)
        public static let canvasMagenta = UIColor(netHex: 0xB42775)
        public static let transparentBackground = UIColor(alpha: 24, red: 0, green: 0, blue: 0)
        public static let settingsGreyBackground = UIColor(netHex: 0xEEEFF1)
        public static let settingsGreyDividerLine = UIColor(netHex: 0xCDCDCF)
        public static let settingsSwitchActive = UIColor(netHex: 0x34C759)
        public static let settingsSwitchInactive = UIColor(argbHex: 0x78788029)
        public static let warningNotification = dangerVariant1
        public static let backgroundWarningNotification = UIColor(alpha: 20, red: 221, green: 110, blue: 110)
        public static let midnightBlue = worksheetQuestionListText
        public static let streakMissedLabel = UIColor(netHex: 0xFED00B)
        public static let streakInactiveLabel = UIColor(netHex: 0x39578F)
        public static let streakDoneColor = canvasGreen
        public static let buttonDisabled = backgroundButtonDisabled
        public static let submitExamResultReward = UIColor(netHex: 0x27AAE1)
        public static let onlineStatusColor = UIColor(netHex: 0x58B17C)
        public static let onlineLessonResult = UIColor(netHex: 0xC8EBFA)
        public static let submitExamResultRewardContainer = UIColor(netHex: 0xE9F7FC)
        public static let examResultPendingStateContainer = UIColor(netHex: 0xFEF4E9)
        public static let examResultApprovedState = UIColor(netHex: 0x439365)
        public static let examResultApprovedStateContainer = UIColor(netHex: 0xEEF8F2)
        public static let genieClassLeaveClassRed = UIColor(netHex: 0xF55C42)
        public static let genieClassLiveRed = genieClassLeaveClassRed
        public static let genieClassSmallClassBlue = UIColor(netHex: 0x335693)
        public static let classReportImproved = genieClassSmallClassBlue
        public static let worksheetCompletionPageBubbleReward = UIColor(netHex: 0x555555)
        public static let worksheetCompletionPageBubbleRewardNote = UIColor.init(white: 1, alpha: 0.8)
        public static let worksheetCompletionBackgroundNotes = UIColor(netHex: 0xFFF7EB)
        public static let genieClassPopExitBackground = UIColor(netHex: 0x4B496E)
        public static let genieClassAlertBackground = UIColor(netHex: 0xFDE5E5)
        public static let geniePostQuizPeek = UIColor(netHex: 0x79A25C)
        public static let onlineClassAlertPeek = UIColor(netHex: 0xD86D6D)
        public static let genieclassFreeTrialBlocker = UIColor(netHex: 0xEEEEF0)
        public static let tooltipBackground = UIColor(argbHex: 0xFF323233)
        public static let scrollThumbColor = UIColor(argbHex: 0xFF6C63FF)
        public static let GBPNavy = UIColor(netHex: 0x262262)
        public static let GBDeepNavy = UIColor(netHex: 0x16133E)
        public static let checkInactiveTint = UIColor(netHex: 0xDCE3EF)
        public static let overlay80 = UIColor(argbHex: 0x80000000)
        public static let onlineLessonQuizSelected = UIColor(netHex: 0x43BDF2)
        public static let formFieldError = UIColor(netHex: 0xC54A47)
        public static let formFieldBorderNormal = UIColor(netHex: 0xCFD7E5)

        /**
         Color Name  Reference V0: https://www.color-name.com/hex/e57b42#color-palettes
         */
        public static let orangeMandarin = UIColor(netHex: 0xE57B41)
        public static let darkSlateBlue = UIColor(netHex: 0x414188)
        public static let blueYonder = UIColor(netHex: 0x496DAE)
        public static let azureishWhite = UIColor(netHex: 0xDCE4F3)
        public static let peachOrange = UIColor(netHex: 0xFCC898)
        public static let lightGray = UIColor(netHex: 0xD5D5D5)
        public static let blueCrayola = UIColor(netHex: 0x1E82F7)
        public static let ghostWhite = UIColor(netHex: 0xFAFBFD)
        public static let darkCornflowerBlue = UIColor(netHex: 0x333F8B)
        public static let coralReef = UIColor(netHex: 0xF77767)
        public static let americanBlue = UIColor(netHex: 0x3E3A6E)
        public static let backgroundBrown = UIColor(netHex: 0x827E7E)
        
        
        public static let yankeesBlue = GBDeepNavy
        public static let mandarin = orangeMandarin
        public static let beer = accentSecondaryDark
        public static let carrotOrange = UIColor(netHex: 0xF79420) // Name comes from https://colors.dopely.top/color-pedia/F79420
        public static let columbiaBlue = formFieldBorderNormal
        public static let batteryChargedBlue = submitExamResultReward
        public static let darkLiver = labelSubtitle
        public static let darkLavender = UIColor(netHex: 0x714E90)
        public static let purpleMountainMajesty = UIColor(netHex: 0x926FB0)
        public static let philippineSilver = borderLight
        public static let venetianRed = formFieldError
        public static let quickSilver = UIColor(netHex: 0xA0A0A0)
        public static let htmlGray = backgroundBrown
        public static let soap = UIColor(netHex: 0xCECDF2)
        public static let aliceBlue = backgroundPrimary1
        public static let veryPaleOrange = UIColor(netHex: 0xFFE2BF)
        public static let water = onlineLessonResult
        public static let brightGray = UIColor(netHex: 0xE5F3F7)
        public static let indigo = GBPNavy
        public static let mediumSeaGreen = UIColor(netHex: 0x48A175)
        public static let lapisLazuli = UIColor(netHex: 0x1B769D)
        public static let pastelRed = UIColor(netHex: 0xF56468)
        public static let englishVermillion = UIColor(netHex: 0xc54a47)
        public static let neptuneDark = UIColor(netHex: 0x30508D)
        public static let neptuneFade = UIColor(netHex: 0xC1D7FF)
        public static let candyRed = UIColor(netHex: 0xE03636)
        public static let redPale = UIColor(netHex: 0xFED6D3)
        public static let indigoRainbow = UIColor(netHex: 0x282962)
        public static let littleBoyBlue = UIColor(netHex: 0x6d93d8)
        public static let CGRed = UIColor(netHex: 0xE03636)
        public static let blackcurrant = UIColor(netHex: 0x16133E)
    }
}
// swiftlint:enable all
