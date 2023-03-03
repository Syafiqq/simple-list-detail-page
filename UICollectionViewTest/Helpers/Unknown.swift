// swiftlint:disable all
//
// Created by engineering on 4/5/23.
//

import Foundation
import UIKit
import SwiftDate
import Kingfisher

class RoundedButton: UIButton {
    private var storedAlpha: CGFloat = 1.0
    private var stillHighlighted: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    override var isHighlighted: Bool {
        didSet {
            if !disabled {
                updateHighlight()
            } else {
                super.isHighlighted = false
            }
        }
    }

    private func updateHighlight() {
        if isHighlighted {
            if !stillHighlighted {
                storedAlpha = alpha
                alpha *= 0.8
            }
            stillHighlighted = true
        } else {
            alpha = storedAlpha
            stillHighlighted = false
        }
    }

    @IBInspectable
    var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable
    var disabled: Bool = false

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}

extension RoundedButton {
    func applyShadow() {
        layer.applySketchShadow(color: UIColor.Genie.dropShadow, alpha: 1.0, x: 1.0, y: 1.0, blur: 3.0)
    }
}

extension UIColor {
    static var random: UIColor {
        .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}

enum DataSource {
    enum Remote {
    }
    enum Cache {
    }
    enum Local {
    }
}

enum Presentation {
    enum UiKit {
    }
}

enum Domain {
}

extension Domain {
}

// MARK: - Calendar
extension Calendar {
    static var appCalendar: Calendar {
        Region.geniebookServerRegion.calendar
    }
}

// MARK: - CONVERSION
extension Date {
    // MARK: Local
    /// This function expect to convert Date to String, `local` term here mean that we will use the system calendar
    /// The source(`Date`) expect to have gregorian value
    /// The localization will applied according to app localization
    ///
    /// ```
    /// 1970-01-01 00:00:00 +0000
    /// ```
    /// ===
    ///
    /// If you find out that the year 1970 of source is one of the following date
    /// you will end up produce incorrect result
    ///
    /// ```
    /// 2513-01-01 00:00:00 +0000 (buddhist version of 1970 gregorian)
    /// 0045-01-01 00:00:00 +0000 (japanese version of 1970 gregorian)
    /// ```
    ///
    /// - Parameters:
    ///   - format: The Date format you are going to use
    ///   - timezone: The Timezone you are going to use
    /// - Returns: Formatted date string with localization
    func toLocalFormattedString(format: String, timezone: TimeZone = Region.current.timeZone) -> String {
        DateFormatter.localDateFormatter(
                        format: format,
                        timezone: timezone
                )
                .string(from: self)
    }

    /// This function is similar to `toLocalFormattedString` but no localization happening.
    /// All the localization will follow english localization
    ///
    /// - Parameters:
    ///   - format: The Date format you are going to use
    ///   - timezone: The Timezone you are going to use
    /// - Returns: Formatted date string without localization
    func toLocalFormattedStringNonLocalized(format: String, timezone: TimeZone = Region.current.timeZone) -> String {
        DateFormatter.localDateFormatter(
                        format: format,
                        timezone: timezone,
                        locale: Locales.english.toLocale()
                )
                .string(from: self)
    }

    // MARK: Server
    /// This function expect to convert Date to String, `server` term here mean that we will use the server date system.
    /// Server Date System:
    /// 1. Gregorian Calendar
    /// 2. +8 Timezone
    /// 3. English Localization
    ///
    /// - Returns: `yyyy-MM-dd HH:mm:ss` server date system
    func toServerDateTimeString() -> String {
        DateFormatter.geniebookServerToDateTime
                .string(from: self)
    }

    /// This function is similar to `toServerDateTimeString` but will take the date only, ignoring the time.
    ///
    /// - Returns: `yyyy-MM-dd` server date system
    func toServerDateString() -> String {
        DateFormatter.geniebookServerToDate
                .string(from: self)
    }

    /// This function expect to similar with `toServerDateTimeString` but give more control for format and timezone
    /// This function will produce the same result with `toServerDateTimeString` implementation
    /// This function will produce the different result with `toServerDateString` implementation due to data truncation
    ///
    /// - Returns: `formatted` server date system
    func toServerFormattedString(format: String, timezone: TimeZone = Region.geniebookServerRegion.timeZone) -> String {
        DateFormatter.serverDateFormatter(
                        format: format,
                        timezone: timezone
                )
                .string(from: self)
    }

    /// This function expect to behave the same as `toServerFormattedString` but will use the english localization
    ///
    /// - Returns: `formatted` server date system
    func toServerFormattedStringNonLocalized(
            format: String,
            timezone: TimeZone = Region.geniebookServerRegion.timeZone
    ) -> String {
        DateFormatter.serverDateFormatter(
                        format: format,
                        timezone: timezone,
                        locale: Locales.english.toLocale()
                )
                .string(from: self)
    }
}

// MARK: - String Extension
extension String {
    // MARK: Local
    /// This function expect to convert String to date, `local` term here mean that we will follow system date.
    /// All date string will be treated as UTC date, calendar will follow system calendar
    ///
    /// - Parameter format: The Date format you are going to use
    /// - Returns:The UTC Date based on the date string provided
    func fromLocalToUtcDate(format: String) -> Date? {
        DateFormatter.localDateFormatter(
                        format: format,
                        timezone: Region.UTC.timeZone,
                        locale: Locale.autoupdatingCurrent
                )
                .date(from: self)
    }

    /// This function similar to `fromLocalToUtcDate`, but the date string will be treated as local timezone
    ///
    /// - Parameter format: The Date format you are going to use
    /// - Returns:The Local Timezone Date based on the date string provided
    func fromLocalToLocalDate(format: String) -> Date? {
        DateFormatter.localDateFormatter(
                        format: format,
                        locale: Locale.autoupdatingCurrent
                )
                .date(from: self)
    }

    // MARK: Server
    /// This function expect to convert String to Date, `server` term here mean that we will use the server date system.
    /// Server Date System:
    /// 1. Gregorian Calendar
    /// 2. +8 Timezone
    /// 3. English Localization
    ///
    /// Input should using to `yyyy-MM-dd HH:mm:ss` format,
    /// - Returns: Local Date, `local` mean will follow current device timezone
    func fromServerToDateTime() -> Date? {
        DateFormatter.geniebookServerToDateTime.date(from: self)
    }

    /// This function similar to `fromServerToDateTime` but expect `yyyy-MM-dd` input
    /// - Returns: Local Date, `local` mean will follow current device timezone
    func fromServerToDate() -> Date? {
        DateFormatter.geniebookServerToDate.date(from: self)
    }

    /// This function similar to `fromServerToDateTime` but expect to retain the date value itself,
    /// Meaning will use local timezone
    ///
    /// - Returns: Local Date, `local` mean will follow current device timezone
    func fromServerToDateTimeButLocalTimezone() -> Date? {
        DateFormatter.geniebookServerToDateTimeButLocalTimezone.date(from: self)
    }

    /// This function similar to `fromServerToDate` but expect `yyyy-MM-dd` input and UTC timezone
    /// Meaning will use utc timezone
    ///
    /// - Returns: UTC Date
    func fromServerToDateButUtc() -> Date? {
        DateFormatter.geniebookServerToDateButUtcTimezone.date(from: self)
    }
}

// MARK: - DateFormatter API Public
extension DateFormatter {
    // MARK: Server
    static var geniebookServerToDateTime: DateFormatter {
        DateFormatter.serverDateFormatter(
                format: "yyyy-MM-dd HH:mm:ss"
        )
    }

    // swiftlint:disable:next identifier_name
    static var geniebookServerToDateTimeButLocalTimezone: DateFormatter {
        DateFormatter.serverDateFormatter(
                format: "yyyy-MM-dd HH:mm:ss",
                timezone: Region.current.timeZone
        )
    }

    static var geniebookServerToDate: DateFormatter {
        DateFormatter.serverDateFormatter(
                format: "yyyy-MM-dd",
                timezone: Region.current.timeZone
        )
    }

    static var geniebookServerToDateButUtcTimezone: DateFormatter {
        DateFormatter.serverDateFormatter(
                format: "yyyy-MM-dd",
                timezone: Region.UTC.timeZone
        )
    }
}

// MARK: - Region
extension Region {
    static var geniebookServerRegion: Region {
        Region(
                calendar: Calendars.gregorian,
                zone: Zones.asiaSingapore,
                locale: Locales.englishSingapore.toLocale()
        )
    }

    static var geniebookServerRegionButLocalZone: Region {
        Region(
                calendar: Calendars.gregorian,
                zone: TimeZone.autoupdatingCurrent,
                locale: Locale.autoupdatingCurrent
        )
    }
}

// MARK: - DateFormatter
private extension DateFormatter {
    // MARK: Local
    static func localDateFormatter(
            format: String,
            timezone: TimeZone = Region.current.timeZone,
            locale: Locale = LocalizationHelper.currentLocale
    ) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = .appCalendar
        dateFormatter.timeZone = timezone
        dateFormatter.locale = locale
        return dateFormatter
    }

    // MARK: Server
    static func serverDateFormatter(
            format: String,
            timezone: TimeZone = Zones.asiaSingapore.toTimezone(),
            locale: Locale = Locales.englishSingapore.toLocale()
    ) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = timezone
        dateFormatter.locale = locale
        return dateFormatter
    }
}

import UIKit
import CRRefresh

public class PullToRefreshAnimator: UIView, CRRefreshProtocol {
    open var view: UIView { return self }
    open var insets: UIEdgeInsets = .zero
    open var trigger: CGFloat  = 60.0
    open var execute: CGFloat  = 60.0
    open var endDelay: CGFloat = 0
    public var hold: CGFloat   = 60
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.hidesWhenStopped = false
        return indicatorView
    }()
    
    public init(frame: CGRect, lightContent: Bool = true) {
        super.init(frame: frame)
        if lightContent {
            indicatorView.color = UIColor.Genie.azureishWhite
        } else {
            indicatorView.color = .gray
        }
        self.addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        setNeedsLayout()
    }
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if finish {
            indicatorView.stopAnimating()
            setNeedsLayout()
        }
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing:
            setNeedsLayout()
        case .pulling:
            self.setNeedsLayout()
        case .idle:
            self.setNeedsLayout()
        default:
            break
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            indicatorView.center = .init(x: w / 2.0, y: h / 2.0)
            if UIDevice.current.userInterfaceIdiom == .phone {
                indicatorView.transform = .identity.scaledBy(x: 0.75, y: 0.75)
            }
        }
    }

}

import Foundation
import RealmSwift

enum RealmHelper {
    static func setup() {
        GeneralDatabase.setupDatabase()
    }

    // MARK: - General Database
    enum GeneralDatabase {
        private static var _configuration: Realm.Configuration?

        static var configuration: Realm.Configuration {
            if _configuration == nil {
                _configuration = Self.generateConfiguration()
            }
            return _configuration ?? Self.generateConfiguration()
        }

        /**
         Obtains a `Realm` instance with the general configuration.

         - parameter queue: An optional dispatch queue to confine the Realm to. If
                            given, this Realm instance can be used from within
                            blocks dispatched to the given queue rather than on the
                            current thread.

         - throws: An `NSError` if the Realm could not be initialized.
         */
        static func instantiate(queue: DispatchQueue? = nil) throws -> Realm {
            try Realm(configuration: configuration)
        }

        fileprivate static func setupDatabase() {
            if let path = configuration.fileURL {
                do {
                    let userDefaults = UserDefaults.standard
                    userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    try FileManager.default.removeItem(at: path)
                    try _ = instantiate()
                } catch {
                    print(error)
                }
            }
        }

        private static func generateConfiguration() -> Realm.Configuration {
            var config = Realm.Configuration.defaultConfiguration
            config.objectTypes = [
            ]
            return config
        }
    }
}


class LogHelper {
    static func logVerbose(_ message: @autoclosure () -> Any){
        print(message())
    }

    static func logDebug(_ message: @autoclosure () -> Any) {
        print(message())
    }

    static func logInfo(_ message: @autoclosure () -> Any) {
        print(message())
    }

    static func logWarning(_ message: @autoclosure () -> Any) {
        print(message())
    }

    static func logError(_ message: @autoclosure () -> Any) {
        print(message())
    }
}

extension Realm {
    func safeWrite(_ block: () throws -> Void) throws {
        if isInWriteTransaction {
            try block()
        } else {
            do {
                try write(withoutNotifying: [], block)
            } catch let error {
                throw error
            }
        }
    }
}

protocol SubjectSwitcherDelegate: AnyObject {
    var pageTitle: String { get }
}

extension CALayer {
    /// https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
    func applySketchShadow(
            color: UIColor = .black,
            alpha: Float = 0.5,
            x: CGFloat = 0,
            y: CGFloat = 2,
            blur: CGFloat = 4,
            spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func removeSketchShadow() {
        shadowColor = nil
        shadowOpacity = 0.0
        shadowOffset = .zero
        shadowRadius = 0.0
        shadowPath = nil
    }
}

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class BlankCell: UICollectionViewCell {
        // MARK: - Outlets
        // MARK: - Constructors
        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

import Foundation
import SwiftEventBus
import SwiftEventBus

public enum PubSubHelper {
    public enum Event: String {
        case renameWorksheet
        case changeDueDate
        case changeMainPageIndex
        case changeSubject
        case changeSubjectInMainTab
        case genieAskInactiveChatIncomingMessage
        case genieAskJumpToMessage
        case genieAskHasClass
        case genieClassOpenSummaryView
        case overrideAppLanguage
        case genieAskPrivateChannelCreated
        case genieAskPrivateChannelSendFirstMessage
        case genieAskDashboardNetworkChange
        case genieClassAskForRatePopup
        case studentSubmitQuestion
        case onWorksheetLocalDbChanged
        case genieclassChangeLevel
        case genieClassOpenOnlineLesson
        case genieClassAttendLiveLesson
        case genieAskSubmitMessage
        case genieClassScheduleLevelChanged
        case genieClassScheduleTopicChanged
    }

    public static func renameWorksheet(_ worksheet: (id: String, name: String)) {
        SwiftEventBus.post(Event.renameWorksheet.rawValue, sender: worksheet)
    }

    public static func changeDueDate(_ worksheet: (id: String, date: Date)) {
        SwiftEventBus.post(Event.changeDueDate.rawValue, sender: worksheet)
    }

    public static func changeMainPage(to: Int) {
        SwiftEventBus.post(Event.changeMainPageIndex.rawValue, sender: to)
    }

    public static func changeSubject(to: String?) {
        SwiftEventBus.post(Event.changeSubject.rawValue, sender: to)
    }

    public static func changeSubjectInMainTab(to: String?) {
        SwiftEventBus.post(Event.changeSubjectInMainTab.rawValue, sender: to)
    }

    public static func publishGenieAskIncomingMessage() {
        SwiftEventBus.post(Event.genieAskInactiveChatIncomingMessage.rawValue)
    }

    public static func publishGenieAskJumpToMessage(of id: String) {
        SwiftEventBus.post(Event.genieAskJumpToMessage.rawValue, sender: id)
    }

    public static func publishGenieAskHasActiveClass() {
        SwiftEventBus.post(Event.genieAskHasClass.rawValue)
    }

    public static func publishOnAppLanguageOverride() {
        SwiftEventBus.post(Event.overrideAppLanguage.rawValue)
    }

    public static func publishGenieAskPrivateChannelCreated() {
        SwiftEventBus.post(Event.genieAskPrivateChannelCreated.rawValue)
    }

    public static func publishGenieAskPrivateChannelSendFirstMessage() {
        SwiftEventBus.post(Event.genieAskPrivateChannelSendFirstMessage.rawValue)
    }

    public static func publishGenieAskDashboardNetworkChange(connected: Bool) {
        SwiftEventBus.post(Event.genieAskDashboardNetworkChange.rawValue, sender: connected)
    }

    public static func publishGenieClassOpenSummaryView() {
        SwiftEventBus.post(Event.genieClassOpenSummaryView.rawValue)
    }

    public static func publishGenieClassAskForRatePopup(onlineLessonId: String) {
        SwiftEventBus.post(Event.genieClassAskForRatePopup.rawValue, sender: onlineLessonId)
    }

    public static func studentSubmitQuestion(studentId: String, subjectId: String, worksheetId: String, partId: String) {
        SwiftEventBus.post(Event.studentSubmitQuestion.rawValue, sender: (studentId, subjectId, worksheetId, partId))
    }

    public static func onWorksheetLocalDbChanged(studentId: String, subjectId: String) {
        SwiftEventBus.post(Event.onWorksheetLocalDbChanged.rawValue, sender: (studentId, subjectId))
    }
    public static func genieclassChangeLevel(level: String) {
        SwiftEventBus.post(Event.genieclassChangeLevel.rawValue, sender: level)
    }
    public static func genieClassOpenOnlineLesson(onlineLessonId: String) {
        SwiftEventBus.post(Event.genieClassOpenOnlineLesson.rawValue, sender: onlineLessonId)
    }

    public static func publishGenieClassAttendLiveLesson(onlineLessonId: String) {
        SwiftEventBus.post(Event.genieClassAttendLiveLesson.rawValue, sender: onlineLessonId)
    }

    public static func publishGenieAskSubmitMessage() {
        SwiftEventBus.post(Event.genieAskSubmitMessage.rawValue)
    }

    public static func publishGenieClassScheduleLevelChanged() {
        SwiftEventBus.post(Event.genieClassScheduleLevelChanged.rawValue)
    }

    public static func publishGenieClassScheduleTopicChanged() {
        SwiftEventBus.post(Event.genieClassScheduleTopicChanged.rawValue)
    }
}

public enum V1DateHelper {
    public enum V1DateHelperType {
        case inAppNotification
        case worksheetUpcomingDateV1(endDate: Date?)
        case worksheetDueDateV1
        case worksheetDateRange(endDate: Date?)
        case worksheetCompletedSubmitDate
        case worksheetRevisionExpiration
        case worksheetGeneratorDueDate
        case genieClassUpcomingDate
    }

    public static func convert(_ date: Date, type: V1DateHelperType, serverDate: Date? = nil) -> String? {
        switch type {
        case .inAppNotification:
            return convertInAppNotificationDate(date, serverDate: serverDate)
        case let .worksheetUpcomingDateV1(endDate):
            return convertWorksheetUpcomingDateV1(startDate: date, endDate: endDate, serverDate: serverDate)
        case let .worksheetDueDateV1:
            return convertWorksheetDueDateV1(dueDate: date, serverDate: serverDate)
        case let .worksheetDateRange(endDate):
            return convertWorksheetDateRange(startDate: date, endDate: endDate)
        case .worksheetCompletedSubmitDate:
            return convertWorksheetCompletedSubmitDate(date)
        case let .worksheetRevisionExpiration:
            return convertWorksheetRevisionExpiration(date, serverDate: serverDate)
        case .worksheetGeneratorDueDate:
            return convertWorksheetDueDateForGeneratorCard(dueDate: date, serverDate: serverDate)
        case let .genieClassUpcomingDate:
            return convertGenieClassUpcomingDate(date)
        }
    }

    public static func isInRange(of date: Date, start: Date?, end: Date?) -> Bool {
        var rDate = DateInRegion(date, region: Region.current)

        var rStart: DateInRegion
        if let start = start {
            rStart = DateInRegion(start, region: Region.current)
        } else {
            rStart = DateInRegion(Date(milliseconds: 0), region: Region.current)
        }

        var rEnd: DateInRegion?
        if let end = end {
            rEnd = DateInRegion(end, region: Region.current)
        }

        if rDate.isAfterDate(rStart, orEqual: true, granularity: .nanosecond) {
            if let end = rEnd {
                return rDate.isBeforeDate(end, orEqual: false, granularity: .nanosecond)
            }
            return true
        }
        return false
    }

    public static func getSecondsDifference(from: Date, notMoreThan: Int = -1) -> Int {
        let secondDifferenceFromDate = Int(Date().timeIntervalSince(from))

        guard notMoreThan > -1 else {
            return secondDifferenceFromDate
        }

        if notMoreThan > secondDifferenceFromDate {
            return notMoreThan - secondDifferenceFromDate
        } else {
            return 0
        }
    }

    public static func convertInAppNotificationDate(_ date: Date, serverDate: Date?) -> String {
        let dateInRegion = DateInRegion(date, region: Region.current)
        let nowInRegion = DateInRegion(serverDate ?? Date(), region: Region.current)
        if dateInRegion.compare(.isToday) {
            let diffInMinutes = dateInRegion.difference(in: .minute, from: nowInRegion) ?? 0
            switch diffInMinutes {
            case ...1:
                return "a_minute_ago".localized
            case ..<60:
                return("\(diffInMinutes) \("time_minutes_ago_display".localized)")
            case 60:
                return("an_hour_ago".localized.lowercased(with: LocalizationHelper.currentLocale))
            default:
                return("\(Int(ceil(Float(diffInMinutes) / 60.0))) \("time_hours_ago_display".localized)")
            }
        } else if dateInRegion.compare(.isYesterday) {
            return("\("time_yesterday".localized), \(dateInRegion.date.toLocalFormattedString(format: "h:mm a"))")
        } else if dateInRegion.compare(.isThisYear) {
            return("\(dateInRegion.date.toLocalFormattedString(format: "d MMM, h:mm a"))")
        } else {
            return("\(dateInRegion.date.toLocalFormattedString(format: "d MMM yyyy"))")
        }
    }

    public static func convertWorksheetUpcomingDateV1(startDate: Date, endDate: Date?, serverDate: Date?) -> String? {
        let dateInRegion = DateInRegion(startDate, region: Region.current)
        let nowInRegion = DateInRegion(serverDate ?? Date(), region: Region.current)
        
        let secondInDiff = nowInRegion.getInterval(toDate: dateInRegion, component: .second)
        if secondInDiff >= 7 * 86_400 {
            let weeks: Int = Int(secondInDiff / (7 * 86_400))
            // TODO: - Localize
            return String(format: "lc_expiring_v1_week_plural".localized, "\(weeks)")
        } else if secondInDiff >= 86_400 {
            let days = secondInDiff / 86_400
            return String(
                    format: days > 1
                            ? "lc_expiring_v1_day_plural".localized
                            : "lc_expiring_v1_day_singular".localized,
                    "\(days)"
            )
        } else if secondInDiff >= 3_600 {
            let hours = secondInDiff / 3_600
            return String(
                    format: hours > 1 
                            ? "lc_expiring_v1_hour_plural".localized
                            : "lc_expiring_v1_hour_singular".localized,
                    "\(hours)"
            )
        } else if secondInDiff >= 1 {
            let result = max(secondInDiff / 60, 1)
            return String(
                    format: result > 1
                            ? "lc_expiring_v1_minute_plural".localized
                            : "lc_expiring_v1_minute_singular".localized,
                    "\(result)"
            )
        } else if dateInRegion.compare(.isEarlier(than: nowInRegion)),
                  let endDate,
                  DateInRegion(endDate, region: Region.current).compare(.isLater(than: nowInRegion)) {
            return String(format: "lc_upcoming_date_v1_ongoing".localized)
        }
        return nil
    }

    static func convertWorksheetDueDateV1(dueDate: Date, serverDate: Date?) -> String? {
        let dateInRegion = DateInRegion(dueDate, region: Region.current)
        let nowInRegion = DateInRegion(serverDate ?? Date(), region: Region.current)
        let limitedUnit = "\("label_due".localized) "
        if dateInRegion < nowInRegion {
            if dateInRegion.compare(.isThisYear) {
                return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM"))"
            } else {
                return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM, yyyy"))"
            }
        } else {
            let diff = nowInRegion.differences(
                in: Set([.day, .hour, .minute, .second]),
                from: dateInRegion
            )
            if var value = diff[.day],
               value > 0 {
                if (diff[.hour] ?? 0) > 12 {
                    value += 1
                }
                if value > 3 {
                    if dateInRegion.compare(.isThisYear) {
                        return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM"))"
                    } else {
                        return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM, yyyy"))"
                    }
                }
                return String(
                        format: value > 1
                                ? "lc_expiring_v1_day_plural".localized
                                : "lc_expiring_v1_day_singular".localized,
                        "\(value)"
                )
            } else if var value = diff[.hour],
                      value > 0 {
                if (diff[.minute] ?? 0) > 30 {
                    value += 1
                }
                if value >= 24 {
                    return String(format: "lc_expiring_v1_day_singular".localized, "1")
                }
                return String(
                        format: value > 1
                                ? "lc_expiring_v1_hour_plural".localized
                                : "lc_expiring_v1_hour_singular".localized,
                        "\(value)"
                )
            } else if var value = diff[.minute],
                      value > 0 {
                if (diff[.second] ?? 0) > 30 {
                    value += 1
                }
                if value >= 60 {
                    return String(format: "lc_expiring_v1_hour_singular".localized, "1")
                }
                return String(
                        format: value > 1
                                ? "lc_expiring_v1_minute_plural".localized
                                : "lc_expiring_v1_minute_singular".localized,
                        "\(value)"
                )
            }
            return String("lc_expiring_v1_second_v1_plural".localized)
        }
    }

    static func convertWorksheetDateRange(startDate: Date, endDate: Date?) -> String? {
        let startInRegion = DateInRegion(startDate, region: Region.current)
        let startDateString: String
        if startInRegion.compare(.isThisYear) {
            startDateString = startDate.toLocalFormattedString(format: "d MMM, hh:mma").lowercased()
        } else {
            startDateString = startDate.toLocalFormattedString(format: "d MMM yyyy, hh:mma").lowercased()
        }
        let endDateString: String
        if let endDate {
            let endInRegion = DateInRegion(endDate, region: Region.current)
            if endInRegion.isInside(date: startInRegion, granularity: .day) {
                endDateString = endDate.toLocalFormattedString(format: " - hh:mma").lowercased()
            } else if endInRegion.compare(.isThisYear) {
                endDateString = endDate.toLocalFormattedString(format: " - d MMM, hh:mma").lowercased()
            } else {
                endDateString = endDate.toLocalFormattedString(format: " - d MMM yyyy, hh:mma").lowercased()
            }
        } else {
            endDateString = ""
        }
        return "\(startDateString)\(endDateString)"
    }

    public static func convertWorksheetCompletedSubmitDate(_ date: Date) -> String {
        let dateInRegion = DateInRegion(date, region: Region.current)
        if dateInRegion.compare(.isThisYear) {
            return date.toLocalFormattedString(format: "d MMM")
        } else {
            return date.toLocalFormattedString(format: "d MMM, yyyy")
        }
    }

    static func convertWorksheetRevisionExpiration(_ date: Date, serverDate: Date?) -> String? {
        let dateInRegion = DateInRegion(date, region: Region.current)
        let nowInRegion = DateInRegion(serverDate ?? Date(), region: Region.current)
        let secondInDiff = nowInRegion.getInterval(toDate: dateInRegion, component: .second)
        let expirationUnit = " \("lc_label_fragment_create_worksheet".localized)"
        if secondInDiff > 3 * 86_400 {
            if dateInRegion.compare(.isThisYear) {
                return "\("subscription_plan_expires_on".localized) \(date.toLocalFormattedString(format: "d MMM"))"
            } else {
                return "\("subscription_plan_expires_on".localized) \(date.toLocalFormattedString(format: "d MMM, yyyy"))" // swiftlint:disable:this line_length
            }
        } else if secondInDiff >= 86_400 {
            let result = secondInDiff / 86_400
            return String(
                    format: result > 1
                            ? "lc_expiring_v1_day_plural".localized + expirationUnit
                            : "lc_expiring_v1_day_singular".localized + expirationUnit,
                    "\(result)"
            )
        } else if secondInDiff >= 3_600 {
            let result = secondInDiff / 3_600
            return String(
                    format: result > 1
                            ? "lc_expiring_v1_hour_plural".localized + expirationUnit
                            : "lc_expiring_v1_hour_singular".localized + expirationUnit,
                    "\(result)"
            )
        } else if secondInDiff >= 60 {
            let result = secondInDiff / 60
            return String(
                    format: result > 1
                            ? "lc_expiring_v1_minute_plural".localized + expirationUnit
                            : "lc_expiring_v1_minute_singular".localized + expirationUnit,
                    "\(result)"
            )
        } else if secondInDiff >= 0 {
            return "lc_expiring_v1_second_v1_plural".localized + expirationUnit
        } else if dateInRegion.compare(.isThisYear) {
            return "\("lc_label_expired_on".localized) \(date.toLocalFormattedString(format: "d MMM"))"
        } else {
            return "\("lc_label_expired_on".localized) \(date.toLocalFormattedString(format: "d MMM, yyyy"))"
        }
    }

    static func convertWorksheetDueDateForGeneratorCard(dueDate: Date, serverDate: Date?) -> String? {
        let dateInRegion = DateInRegion(dueDate, region: Region.current)
        let nowInRegion = DateInRegion(serverDate ?? Date(), region: Region.current)
        let limitedUnit = "\("lc_label_limited_time".localized): "
        if dateInRegion < nowInRegion {
            if dateInRegion.compare(.isThisYear) {
                return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM"))"
            } else {
                return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM, yyyy"))"
            }
        } else {
            let diff = nowInRegion.differences(
                in: Set([.day, .hour, .minute, .second]),
                from: dateInRegion
            )
            if var value = diff[.day],
               value > 0 {
                if (diff[.hour] ?? 0) > 12 {
                    value += 1
                }
                if value > 7 {
                    if dateInRegion.compare(.isThisYear) {
                        return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM"))"
                    } else {
                        return "\(limitedUnit)\(dueDate.toLocalFormattedString(format: "d MMM, yyyy"))"
                    }
                }
                return limitedUnit + String(
                        format: value > 1
                                ? "lc_expiring_v1_day_plural".localized
                                : "lc_expiring_v1_day_singular".localized,
                        "\(value)"
                )
            } else if var value = diff[.hour],
                      value > 0 {
                if (diff[.minute] ?? 0) > 30 {
                    value += 1
                }
                if value >= 24 {
                    return limitedUnit + String(format: "lc_expiring_v1_day_singular".localized, "1")
                }
                return limitedUnit + String(
                        format: value > 1
                                ? "lc_expiring_v1_hour_plural".localized
                                : "lc_expiring_v1_hour_singular".localized,
                        "\(value)"
                )
            } else if var value = diff[.minute],
                      value > 0 {
                if (diff[.second] ?? 0) > 30 {
                    value += 1
                }
                if value >= 60 {
                    return limitedUnit + String(format: "lc_expiring_v1_hour_singular".localized, "1")
                }
                return limitedUnit + String(
                        format: value > 1
                                ? "lc_expiring_v1_minute_plural".localized
                                : "lc_expiring_v1_minute_singular".localized,
                        "\(value)"
                )
            }
            return limitedUnit + String("lc_expiring_v1_second_v1_plural".localized)
        }
    }

    public static func convertGenieClassUpcomingDate(_ date: Date) -> String? {
        let dateInRegion = DateInRegion(date, region: Region.current)
        if dateInRegion.compare(.isThisYear) {
            return date.toLocalFormattedString(format: "d MMM, h:mm a")
        }
        return date.toLocalFormattedString(format: "d MMM yyyy, h:mm a")
    }
}

enum GBCore {
    enum Presentation {
        enum UiKit {
        }
    }
}

extension GBCore.Presentation.UiKit {
    enum V1ViewGeneratorHelper {
        public static func generateGenericViewDesign() -> UIView {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }

        public static func generateViewForSpaceBackdropV1Design() -> UIView {
            let view = generateGenericViewDesign()
            view.backgroundColor = UIColor(netHex: 0x16133E)
            return view
        }

        public static func generateViewForSpaceBackdropV2Design() -> UIView {
            let view = generateGenericViewDesign()
            view.backgroundColor = UIColor(netHex: 0x16133E)
            return view
        }
    }
}

enum UiKitErrorHandlerHelper {
    static func defaultDialogErrorHandler(
            _ sender: UIViewController?,
            withTitle title: String,
            error: Error,
            closeOnTapOverlay: Bool = true,
            showCloseButton: Bool = true,
            onComplete: @escaping () -> Void
    ) {
        onComplete()
    }
}

class V1UIViewController: UIViewController {
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    static let yyyyMMdd_HHmmss: DateFormatter = {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()
}

extension DateFormatter {
    static let yyyyMMdd_HHmmss_server = serverFormat(dateFormat: "yyyy-MM-dd HH:mm:ss")
    static let yyyyMMdd_server = serverFormat(dateFormat: "yyyy-MM-dd")

    static func serverFormat(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = .gregorian
        formatter.timeZone = Zones.asiaSingapore.toTimezone()
        formatter.locale = Locales.englishSingapore.toLocale()
        return formatter
    }
}

enum DateHelper {
    static var serverRegion: Region {
        Region(
                calendar: Calendar.gregorian,
                zone: Zones.asiaSingapore,
                locale: Locales.englishSingapore.toLocale()
        )
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
// swiftlint:enable all

// swiftlint:disable all
extension GBCore.Presentation.UiKit {
    public class UIButtonObliqueBottomLeft: UIButton {
        public var foregroundColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var pressedColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var unPressedColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var backgroundColorShadow: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var disabledColor: UIColor? {
            didSet {
                refreshColor()
            }
        }

        override public var isEnabled: Bool {
            didSet {
                refreshState()
            }
        }

        public weak var unPressedGradient: CAGradientLayer?

        override public init(frame: CGRect) {
            super.init(frame: frame)

            initDesign()
            initEvents()
            refreshColor()
            refreshState()
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            unPressedGradient?.frame = bounds
        }

        @objc
        private func statePressed() {
            guard isEnabled else {
                stateDisabled()
                return
            }
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseIn,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.pressedColor ?? Color.pressedColor
                        self.transform = .identity.translatedBy(x: -2, y: 3)
                        self.layer.removeSketchShadow()
                    },
                    completion: { _ in }
            )
        }

        @objc
        private func stateUnPressed() {
            guard isEnabled else {
                stateDisabled()
                return
            }
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseOut,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.unPressedColor ?? Color.unPressedColor
                        self.transform = .identity
                        self.layer.applySketchShadow(
                                color: self.backgroundColorShadow ?? Color.backgroundColorShadow,
                                alpha: 1.0,
                                x: -2.0,
                                y: 3.0,
                                blur: 0.0
                        )
                    },
                    completion: { _ in }
            )
        }

        @objc
        private func stateDisabled() {
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseIn,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.disabledColor ?? Color.disabledColor
                        self.transform = .identity.translatedBy(x: -2, y: 3)
                        self.layer.removeSketchShadow()
                    },
                    completion: { _ in }
            )
        }

        private func refreshColor() {
            tintColor = foregroundColor ?? Color.foregroundColor
            setTitleColor(foregroundColor ?? Color.foregroundColor, for: .normal)
            refreshState()
        }

        private func refreshState() {
            stateUnPressed()
        }
    }
}

extension GBCore.Presentation.UiKit.UIButtonObliqueBottomLeft {
    private func initEvents() {
        addTarget(self, action: #selector(statePressed), for: .touchDown)
        addTarget(self, action: #selector(statePressed), for: .touchDragEnter)
        addTarget(self, action: #selector(stateUnPressed), for: .touchDragExit)
        addTarget(self, action: #selector(stateUnPressed), for: .touchUpInside)
        addTarget(self, action: #selector(stateUnPressed), for: .touchUpOutside)
    }

    private func initDesign() {
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: 42)
        refreshColor()
    }
}

extension GBCore.Presentation.UiKit.UIButtonObliqueBottomLeft {
    enum Color {
        static let foregroundColor = UIColor.white
        static let backgroundColor = UIColor.Genie.accentSecondaryDark
        static let unPressedColor = backgroundColor
        static let pressedColor = backgroundColor
        static let backgroundColorShadow = UIColor.Genie.orangeMandarin
        static let disabledColor = UIColor.Genie.borderLight
    }
}

// MARK: - LIFECYCLE AND CALLBACK

extension GBCore.Presentation.UiKit {
    class VGradientView: UIView {
        // MARK: Outlets

        // MARK: ViewModel

        // MARK: Private Properties

        // MARK: Data

        // MARK: Public Properties

        override class var layerClass: AnyClass {
            CAGradientLayer.self
        }

        var startColor: UIColor? {
            didSet { gradientLayer?.colors = cgColorGradient }
        }

        var endColor: UIColor? {
            didSet { gradientLayer?.colors = cgColorGradient }
        }

        var startPoint: CGPoint = .zero {
            didSet { gradientLayer?.startPoint = startPoint }
        }

        var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
            didSet { gradientLayer?.endPoint = endPoint }
        }

        var locations: [NSNumber] = [] {
            didSet { gradientLayer?.locations = locations }
        }

        // swiftlint:disable:next discouraged_optional_collection
        var cgColorGradient: [CGColor]? {
            guard let startColor = startColor, let endColor = endColor else {
                return nil
            }

            return [startColor.cgColor, endColor.cgColor]
        }

        var gradientLayer: CAGradientLayer? {
            layer as? CAGradientLayer
        }

        // MARK: Initialization

        // MARK: Lifecycle

        // MARK: Override Function

        // MARK: Callback

        // MARK: Public Function

        // MARK: Deinitialization

        deinit {
        }
    }
}

// swiftlint:disable all
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
                x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
                x: locationOfTouchInLabel.x - textContainerOffset.x,
                y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex) ..< self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }

    func quoteEscape() -> String {
        var escaped = self
        escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")
        escaped = escaped.replacingOccurrences(of: "\'", with: "\\\'")
        escaped = escaped.replacingOccurrences(of: "\"", with: "\\\"")
        escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")
        escaped = escaped.replacingOccurrences(of: "\r", with: "\\r")
        escaped = escaped.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        escaped = escaped.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        return escaped
    }

    func capitalizingFirstLetter() -> String {
        "\(prefix(1))".capitalized(with: LocalizationHelper.currentLocale) + dropFirst()
    }
}

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { removeArrangedSubViewProperly($0) }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}

public protocol Dialogable: AnyObject {
    var isShowing: Bool { get }
    var type: DialogType? { get set }
    func show()
    func removeSelf()
    var targetPage: UIViewController? { get set }
}

public enum DialogType: Equatable {
    case deferred
    case notiPermission
    case onboardingIntro
    case onboardingTrialEnd
    case onboardingSubscriptionEnd
    case onboardingGenerateWorksheet
    case onboardingWorksheetBubble
    case onboardingProgress
    case onboardingGenieClass
    case onboardingGenieAsk
    case onboardingUiUxAnnouncer
    case npsSurvey
    case genieaskPromo
    case iapPending
    case tooltipGenerateWorksheet
    case fixedClassTooltip

    // MARK: Popup
    case genieClassPopUp
    case genieClassToGenieSmart
    case acquireBadges(ids: String)
    case arenaPopUp
    case exitWorksheetPopup
}

public extension DialogType {
    var priority: Int {
        switch self {
        case .deferred: return Int.min
        case .notiPermission: return 1
        case .onboardingTrialEnd: return 2
        case .onboardingSubscriptionEnd: return 2
        case .onboardingIntro: return 3
        case .onboardingGenerateWorksheet: return 4
        case .onboardingProgress: return 4
        case .onboardingGenieClass: return 4
        case .onboardingGenieAsk: return 4
        case .onboardingWorksheetBubble: return 5
        case .onboardingUiUxAnnouncer: return 3
        case .npsSurvey: return 7
        case .genieaskPromo: return 9
        case .iapPending: return 13
        case .genieClassPopUp: return 9
        case .genieClassToGenieSmart: return 9
        case .acquireBadges: return 8
        case .arenaPopUp: return 11
        case .fixedClassTooltip: return 9

        // General popup
        case .exitWorksheetPopup: return 12
        case .tooltipGenerateWorksheet: return 6

        }
    }
}

open class DialogView: UIView, Dialogable {
    open var type: DialogType?
    open var isShowing: Bool = false
    weak open var targetPage: UIViewController?

    open func show() {
        isShowing = true
    }

    open func removeSelf() {
        isShowing = false
    }
}

extension UIView {
    /// This function is to get the correct rect position relative to the given view
    ///
    /// - Parameters:
    ///   - view: Target view
    ///   - internalRect: The internal rect going to be processed, instead of `self.frame`
    ///   - inset: inset to be added in resultant rect
    /// - Returns:
    func getRect(
            relativeTo view: UIView,
            internalRect: CGRect?,
            inset: UIEdgeInsets
    ) -> CGRect? {
        let parentFrame = view

        var frameToBeProcessed = frame
        if let internalRect = internalRect {
            frameToBeProcessed = self.convert(internalRect, to: self.superview)
        }

        // We need to calculate the targeted frame relative to whole target frame
        guard var frameToBeProcessed = self.superview?.convert(frameToBeProcessed, to: parentFrame) else {
            return nil
        }

        // Apply Padding
        let rectPadding = inset
        frameToBeProcessed = CGRect(
                x: frameToBeProcessed.minX + rectPadding.left,
                y: frameToBeProcessed.minY + rectPadding.top,
                width: frameToBeProcessed.width - rectPadding.left - rectPadding.right,
                height: frameToBeProcessed.height - rectPadding.top - rectPadding.bottom
        )

        return frameToBeProcessed
    }
}

extension Domain {
    struct LevelEntity: Codable {
        var shortLevelName: String
        var levelId: String?
        var levelName: String
    }
}

class LevelHelper {
    static let shared: LevelHelper = LevelHelper()
    static let defaultLevel = -999
    static let levelMapping: [String: Int] = ["-1": 1, "0": 2, "1": 3, "2": 4, "3": 5, "4": 6, "5": 7, "6": 8, "7": 9, "8": 10, "9": 11, "10": 12, "14": 13, "11": 14, "12": 15, "small_class": 16, "rocketeers" : 17]
    static let levelMappingInt: [Int: Int] = [-1: 1, 0: 2, 1: 3, 2: 4, 3: 5, 4: 6, 5: 7, 6: 8, 7: 9, 8: 10, 9: 11, 10: 12, 14: 13, 11: 14, 12: 15]
    private var levels: [Domain.LevelEntity] = {
        let levelsRaw: [(String, String, String)] = [
            ( "1", "P1", "Primary 1" ),
            ( "2", "P2", "Primary 2" ),
            ( "3", "P3", "Primary 3" ),
            ( "4", "P4", "Primary 4" ),
            ( "5", "P5", "Primary 5" ),
            ( "6", "P6", "Primary 6" ),
            ( "7", "S1", "Secondary 1" ),
            ( "8", "S2", "Secondary 2" ),
            ( "9", "S3", "Secondary 3" ),
            ( "10", "S4", "Secondary 4" ),
            ( "-4", "PG", "Playgroup" ),
            ( "-3", "N1", "Nursery 1" ),
            ( "-2", "N2", "Nursery 2" ),
            ( "-1", "K1", "Kindergarten 1" ),
            ( "0", "K2", "Kindergarten 2" ),
            ( "14", "S5", "Secondary 5" ),
            ( "11", "JC 1", "JC 1" ),
            ( "12", "JC 2", "JC 2" ),
            ( "99", "GRAD", "Graduated" )
        ]
        return levelsRaw.map { Domain.LevelEntity(shortLevelName: $0.1, levelId: $0.0, levelName: $0.2) }
    }()

    static func getLevelMapping(levelInts: [String], long: Bool) -> [(String, String)] {
        levelInts.map {
            let levelInt = $0
            guard let level = LevelHelper.shared.levels.first(where: { $0.levelId == "\(levelInt)" }) else {
                    // in this case small_class is not listed in get_level_list so temporary using this code to manual map small_class
                    // need to remove this code after backend decided to insert it to level list
                    if levelInt == "small_class" {
                        return ($0, "1v4")
                    } else if levelInt == "rocketeers" {
                        return ($0, "rocketeers")
                    } else if levelInt == "disabled" {
                        return ($0, "disabled")
                    }
                    return nil
                }
            return ($0, long ? level.levelName : level.shortLevelName)
        }
        .compactMap { $0 }
    }

    static func getName(levelId: String, shorten: Bool) -> String? {
        let levelVM = LevelHelper.shared.levels.first { $0.levelId == levelId }
        return shorten ? levelVM?.shortLevelName : levelVM?.levelName
    }

    static func getId(shortLevelName: String) -> Int? {
        LevelHelper.shared.levels.first {
            $0.shortLevelName == shortLevelName
        }?.levelId?.toInt()
    }

    static func getName(levelIds: String, shorten: Bool = true) -> String {
        return levelIds
            .components(separatedBy: ",")
            .compactMap { LevelHelper.getName(levelId: $0, shorten: shorten) }
            .joined(separator: ",")
    }

    /// This function will process topic level and return filtered and sorted topic level
    /// - Parameter levels: topic level joinend with comma
    /// - Returns: filtered & sorted topic level joined as string with comma.
    static func getLevelBellowUserLevel(levels: String, userLevel: Int) -> String {
        levels
                .split(separator: ",")
                .map { (level: String.SubSequence) -> Int in (Int(level) ?? LevelHelper.defaultLevel)}
                .filter { (level: Int) -> Bool in level <= userLevel}
                .sorted(by: { (level1: Int, level2: Int) -> Bool in level1 > level2 })
                .map { (level: Int) -> String in String(level)}
                .joined(separator: ",")
    }

    /// This function will process topic level and return filtered and sorted topic level name
    /// - Parameter levels: topic level joinend with comma
    /// - Returns: filtered & sorted topic level name joined as string with comma.
    static func getLevelNameBellowUserLevel(levels: String, userLevel: Int) -> String {
        levels
                .split(separator: ",")
                .map { (level: String.SubSequence) -> Int in (Int(level) ?? LevelHelper.defaultLevel)}
                .filter { (level: Int) -> Bool in level <= userLevel}
                .sorted(by: { (level1: Int, level2: Int) -> Bool in level1 > level2 })
                .map { (level: Int) -> String in getName(levelId: level.description, shorten: true) ?? ""}
                .joined(separator: ",")
    }

    /// This function will process topic level and return filtered and sorted topic level name
    /// - Parameter levelsName: topic level name array
    /// - Returns: filtered & sorted topic level name array.
    static func getLevelNameBellowUserLevel(levelsName: [String], userLevel: Int) -> [String] {
        levelsName
                .map { (level: String) -> Int in (getId(shortLevelName: level) ?? LevelHelper.defaultLevel)}
                .filter { (level: Int) -> Bool in level <= userLevel}
                .sorted(by: { (level1: Int, level2: Int) -> Bool in level1 > level2 })
                .map { (level: Int) -> String in getName(levelId: level.description, shorten: true) ?? ""}
    }

}

extension LevelHelper {
    static func getSchoolProgramId(levelId: String) -> Int {
        guard let levelInt = Int(levelId) else {
            return 0
        }

        if [-1, 0].contains(levelInt) {
            return 0
        } else if [1, 2, 3, 4, 5, 6].contains(levelInt) {
            return 1
        } else if [7, 8, 9, 10, 14].contains(levelInt) {
            return 2
        } else if [11, 12].contains(levelInt) {
            return 3
        }

        return 0
    }
}

extension UIApplication {
    class func topAppViewController(controller: UIViewController? = AppCompatHelper.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topAppViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topAppViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topAppViewController(controller: presented)
        }
        return controller
    }
}

extension NSMutableAttributedString {
    func addImageAttachment(image: UIImage, font: UIFont, textColor: UIColor, size: CGSize? = nil) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: textColor,
            .foregroundColor: textColor,
            .font: font
        ]

        self.append(
                NSAttributedString(
                        // U+200C (zero-width non-joiner)
                        // is a non-printing character. It will not paste unnecessary space.
                        string: "\u{200c}",
                        attributes: textAttributes
                )
        )

        let attachment = NSTextAttachment()
        attachment.image = image.withRenderingMode(.alwaysTemplate)
        let imageSize = CGSize(width: size?.width ?? 0, height: size?.height ?? 0)
        attachment.bounds = CGRect(
                x: 0,
                y: (font.capHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
        )
        let attachmentString = NSMutableAttributedString(attachment: attachment)
        attachmentString.addAttributes(
                textAttributes,
                range: NSRange(
                        location: 0,
                        length: attachmentString.length
                )
        )
        self.append(attachmentString)
    }
}

import SnapKit
import LifetimeTracker

extension Constants {
    static let TOAST_TOP_TAG = 1
    static let TOAST_BOTTOM_TAG = 2
}

// MARK: - LIFECYCLE AND CALLBACK

extension Presentation.UiKit {
    class VToastView1: UIView {
        // MARK: Outlets

        private var vwStackContainer: UIStackView?
        private var ivIcon: UIImageView?
        private var lbTitle: UILabel?
        private var btCta: UIButton?

        private var constraintIconCenterYToParentCenterY: Constraint?
        private var constraintCtaInline = [Constraint]()

        // MARK: ViewModel

        // MARK: Service

        // MARK: Vc Provider

        // MARK: Private Properties

        private var autoHideWorkItem: DispatchWorkItem?

        private var ctaAction: (() -> Void)?

        private var displayProperties: DisplayProperties = .default

        // MARK: Data

        // MARK: Public Properties

        var constraintToShow: Constraint?
        var constraintToHide: Constraint?

        // MARK: Initialization

        public override init(frame: CGRect) {
            super.init(frame: frame)

            initDesign()
            initViews()
            initEvents()

            #if DEBUG
            trackLifetime()
            #endif
        }

        public required init?(coder: NSCoder) {
            fatalError("not yet implemented")
        }

        // MARK: Lifecycle

        // MARK: Override Function

        // MARK: Callback

        @objc
        private func onContainerTapped() {
            clearAutoHideAndHide(animated: displayProperties.animated, andDestroy: displayProperties.destroyWhenDismissed)
        }

        @objc
        private func onCtaTapped() {
            hideView(animated: displayProperties.animated, andDestroy: displayProperties.destroyWhenDismissed)
            ctaAction?()
        }

        // MARK: Public Function

        public func updateUi(
                text: String,
                type: ToastType = .default,
                customIcon: UIImage? = nil,
                ctaText: NSAttributedString? = nil,
                ctaAction: @escaping () -> Void,
                displayProperties: DisplayProperties
        ) {
            self.displayProperties = displayProperties
            doUpdateUi(
                    withMessage: text,
                    type: type,
                    customIcon: customIcon,
                    ctaText: ctaText
            )
            self.ctaAction = ctaAction
            if displayProperties.autoDismiss {
                setupAutoHide()
            }
        }

        public func showView(animated: Bool) {
        }

        public func hideView(animated: Bool, andDestroy destroy: Bool = false) {
        }

        public func destroy() {
            removeFromSuperview()
        }

        // MARK: Deinitialization

        deinit {
            clearAutoHideWorkItem()
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension Presentation.UiKit.VToastView1 {
    // MARK: Init Functions

    func initViews() {
        hideView(animated: false)
    }

    func initEvents() {
        isUserInteractionEnabled = true
        addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(onContainerTapped))
        )
        btCta?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(onCtaTapped))
        )
    }

    // MARK: Views

    func doUpdateUi(
            withMessage message: String,
            type: ToastType,
            customIcon: UIImage?,
            ctaText: NSAttributedString? = nil
    ) {
        // Text
        if case .inline(let additionalSpace) = displayProperties.ctaDisplayStyle {
            let numOfSpaces = (ctaText?.length ?? 0) + additionalSpace
            lbTitle?.text = "\(message) \(String(repeating: "\u{200C}\u{00A0}", count: numOfSpaces))"
            
        } else {
            lbTitle?.text = message
        }

        // Image
        let imageAsset: UIImage?
        switch type {
        case .default:
            imageAsset = customIcon
        case .success:
            imageAsset = customIcon ?? UIImage(named: "ic_check_circle_solid_24")
        case .error:
            imageAsset = customIcon ?? UIImage(named: "ic_times_circle_solid")
        case .warning:
            imageAsset = customIcon ?? UIImage(named: "ic_fa_triangle_exclamation_solid_24")?
                .tinted(color: UIColor.Genie.textPrimaryDark)
        }
        if let imageAsset {
            ivIcon?.image = imageAsset
        } else {
            ivIcon?.image = nil
        }

        // Cta
        btCta?.setAttributedTitle(ctaText, for: .normal)

        // Visibility
        if !displayProperties.showIcon || ivIcon?.image == nil {
            ivIcon?.isHidden = true
        } else {
            ivIcon?.isHidden = false
        }
        btCta?.isHidden = ctaText == nil
        switch displayProperties.iconVerticalAlign {
        case .center:
            constraintIconCenterYToParentCenterY?.activate()
        case .alignBaseline:
            constraintIconCenterYToParentCenterY?.deactivate()
        }

        if let btCta {
            switch displayProperties.ctaDisplayStyle {
            case .dedicatedSpace:
                constraintCtaInline.forEach {
                    $0.deactivate()
                }
                btCta.removeFromSuperview()
                vwStackContainer?.addArrangedSubview(btCta)
                btCta.contentEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 0);
            case .inline:
                btCta.removeFromSuperview()
                addSubview(btCta)
                constraintCtaInline.forEach {
                    $0.activate()
                }
                btCta.contentEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 12);
            }
        } else {
            btCta?.removeFromSuperview()
        }

        // Color
        switch type {
        case .default:
            ivIcon?.tintColor = Color.foregroundPrimary
            lbTitle?.textColor = Color.foregroundPrimary
            lbTitle?.font = FontHelper.SHSans.bold.font(16)
            backgroundColor = Color.backgroundDefault
        case .success:
            ivIcon?.tintColor = Color.foregroundPrimary
            lbTitle?.textColor = Color.foregroundPrimary
            lbTitle?.font = FontHelper.SHSans.bold.font(16)
            backgroundColor = Color.backgroundSuccess
        case .error:
            ivIcon?.tintColor = Color.foregroundPrimary
            lbTitle?.textColor = Color.foregroundPrimary
            lbTitle?.font = FontHelper.SHSans.bold.font(16)
            backgroundColor = Color.backgroundError
        case .warning:
            ivIcon?.tintColor = Color.foregroundWarning
            lbTitle?.textColor = Color.foregroundWarning
            lbTitle?.font = FontHelper.SHSans.bold.font(16)
            backgroundColor = Color.backgroundWarning
        }
    }

    func setupAutoHide() {
        clearAutoHideWorkItem()
        let autoHideWorkItem = DispatchWorkItem { [weak self] in
            guard let self else {
                return
            }
            self.clearAutoHideAndHide(animated: self.displayProperties.animated, andDestroy: self.displayProperties.destroyWhenDismissed)
        }
        self.autoHideWorkItem = autoHideWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: autoHideWorkItem)
    }

    func clearAutoHideWorkItem() {
        autoHideWorkItem?.cancel()
        autoHideWorkItem = nil
    }

    func clearAutoHideAndHide(animated: Bool, andDestroy destroy: Bool = false) {
        clearAutoHideWorkItem()
        hideView(animated: animated, andDestroy: destroy)
    }

    // MARK: ViewModel

    // MARK: Event Bus

    // MARK: Model
}

// MARK: - COORDINATOR

// MARK: - ANALYTICS

// MARK: - DELEGATIONS

// MARK: - EXTENSION

extension Presentation.UiKit.VToastView1 {
    enum ToastType: Int {
        case `default` = 1
        case success = 2
        case error = 3
        case warning = 4
    }
}

extension Presentation.UiKit.VToastView1 {
    struct DisplayProperties {
        let showIcon: Bool
        let autoDismiss: Bool
        let animated: Bool
        let tag: Int
        let destroyWhenDismissed: Bool
        let iconVerticalAlign: IconVerticalLayout
        let ctaDisplayStyle: CtaDisplayStyle
        let maxWidthPad: CGFloat?
        let maxWidthPhone: CGFloat?
        let showSpace: CGFloat

        init(
                showIcon: Bool = true,
                autoDismiss: Bool = true,
                animated: Bool = true,
                tag: Int = Constants.TOAST_TOP_TAG,
                destroyWhenDismissed: Bool = true,
                iconVerticalAlign: IconVerticalLayout = .center,
                ctaDisplayStyle: CtaDisplayStyle = .dedicatedSpace,
                maxWidthPad: CGFloat? = nil,
                maxWidthPhone: CGFloat? = nil,
                showSpace: CGFloat = 16
        ) {
            self.showIcon = showIcon
            self.autoDismiss = autoDismiss
            self.animated = animated
            self.tag = tag
            self.destroyWhenDismissed = destroyWhenDismissed
            self.iconVerticalAlign = iconVerticalAlign
            self.ctaDisplayStyle = ctaDisplayStyle
            self.maxWidthPad = maxWidthPad
            self.maxWidthPhone = maxWidthPhone
            self.showSpace = showSpace
        }

        func copyWith(
                showIcon: Bool? = nil,
                autoDismiss: Bool? = nil,
                animated: Bool? = nil,
                tag: Int? = nil,
                destroyWhenDismissed: Bool? = nil,
                iconVerticalAlign: IconVerticalLayout? = nil,
                ctaDisplayStyle: CtaDisplayStyle? = nil,
                maxWidthPad: CGFloat? = nil,
                maxWidthPhone: CGFloat? = nil,
                showSpace: CGFloat? = nil
        ) -> DisplayProperties {
            DisplayProperties(
                    showIcon: showIcon ?? self.showIcon,
                    autoDismiss: autoDismiss ?? self.autoDismiss,
                    animated: animated ?? self.animated,
                    tag: tag ?? self.tag,
                    destroyWhenDismissed: destroyWhenDismissed ?? self.destroyWhenDismissed,
                    iconVerticalAlign: iconVerticalAlign ?? self.iconVerticalAlign,
                    ctaDisplayStyle: ctaDisplayStyle ?? self.ctaDisplayStyle,
                    maxWidthPad: maxWidthPad ?? self.maxWidthPad,
                    maxWidthPhone: maxWidthPhone ?? self.maxWidthPhone,
                    showSpace: showSpace ?? self.showSpace
            )
        }
    }
}

extension Presentation.UiKit.VToastView1.DisplayProperties {
    enum IconVerticalLayout {
        case center
        case alignBaseline
    }

    enum CtaDisplayStyle {
        case dedicatedSpace
        case inline(Int)
    }
}

extension Presentation.UiKit.VToastView1.DisplayProperties {
    static let `default` = Self()
}

// MARK: - STATIC DETACHABLE

// MARK: - DESIGN

private extension Presentation.UiKit.VToastView1 {
    func initDesign() {
        // View Initialization
        layer.cornerRadius = 16

        let vwContentContainer = generateGenericViewDesign()
        let vwStackContainer = generateViewForContainerDesign()
        let ivIconContainer = generateGenericViewDesign()
        let ivIcon = generateIconDesign()
        let lbTitle = generateTitleLabelDesign()
        let btCta = generateCtaButtonDesign()

        var constraintIconCenterYToParentCenterY: Constraint?
        var constraintCtaInline = [Constraint]()

        // View Graph
        addSubview(vwContentContainer)
        vwContentContainer.addSubview(vwStackContainer)
        vwStackContainer.addArrangedSubview(ivIconContainer)
        ivIconContainer.addSubview(ivIcon)
        vwStackContainer.addArrangedSubview(lbTitle)
        addSubview(btCta)

        // View Constraints
        vwContentContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.directionalEdges
                    .equalToSuperview()
                    .inset(UIEdgeInsets(vertical: 16, horizontal: 24))
        }
        vwStackContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.directionalEdges
                    .equalToSuperview()
        }
        ivIconContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.bottom
                .equalToSuperview()
        }
        ivIcon.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                    .greaterThanOrEqualToSuperview()
                    .offset(4)
                    .priority(999)
            make.leading.trailing
                    .equalToSuperview()
            constraintIconCenterYToParentCenterY = make.centerY
                    .equalToSuperview()
                    .constraint
            make.size
                    .equalTo(20)
        }
        btCta.snp.makeConstraints { make in
            let constraintTrailing = make.trailing
                    .equalToSuperview()
                    .offset(-4)
                    .constraint
            let constraintBottom = make.bottom
                    .equalToSuperview()
                    .constraint
            constraintCtaInline.append(constraintTrailing)
            constraintCtaInline.append(constraintBottom)
        }

        constraintCtaInline.forEach {
            $0.deactivate()
        }

        ivIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        btCta.setContentCompressionResistancePriority(.required, for: .horizontal)

        // View Assign
        self.vwStackContainer = vwStackContainer
        self.ivIcon = ivIcon
        self.lbTitle = lbTitle
        self.btCta = btCta
        self.constraintIconCenterYToParentCenterY = constraintIconCenterYToParentCenterY
        self.constraintCtaInline = constraintCtaInline
    }

    private func generateGenericViewDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func generateViewForContainerDesign() -> UIStackView {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 16
        return view
    }

    func generateIconDesign() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Color.foregroundPrimary
        return view
    }

    func generateTitleLabelDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Color.foregroundPrimary
        view.font = FontHelper.SHSans.bold.font(16)
        view.numberOfLines = 0
        return view
    }

    func generateCtaButtonDesign() -> UIButton {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

}

// MARK: - COLOR

private extension Presentation.UiKit.VToastView1 {
    enum Color {
        static let foregroundPrimary = UIColor.white
        static let foregroundWarning = UIColor.Genie.textPrimaryDark
        
        static let backgroundError = UIColor.Genie.coralReef
        static let backgroundDefault = UIColor.Genie.backgroundBrown
        static let backgroundSuccess = UIColor(netHex: 0x48A074)
        static let backgroundWarning = UIColor(netHex: 0xFED00B)
    }
}

// MARK: - TRACKING

#if DEBUG
extension Presentation.UiKit.VToastView1: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        LifetimeConfiguration(maxCount: 1)
    }
}
#endif


extension Presentation.UiKit {
    class VToastTopView1: VToastView1 {
        public override func showView(animated: Bool) {
            if superview == nil {
                return
            }
            constraintToHide?.deactivate()
            constraintToShow?.activate()
            alpha = 0
            if animated {
                UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        options: UIView.AnimationOptions.curveEaseIn,
                        animations: { [weak self] in
                            self?.superview?.layoutIfNeeded()
                            self?.alpha = 1
                        },
                        completion: { [weak self] success in
                            if success {
                                self?.alpha = 1
                            }
                        }
                )
            } else {
                alpha = 1
            }
        }

        public override func hideView(animated: Bool, andDestroy destroy: Bool = false) {
            if superview == nil {
                return
            }
            constraintToShow?.deactivate()
            constraintToHide?.activate()
            alpha = 1
            if animated {
                UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        options: UIView.AnimationOptions.curveEaseOut,
                        animations: { [weak self] in
                            self?.superview?.layoutIfNeeded()
                            self?.alpha = 0
                        },
                        completion: { [weak self] success in
                            self?.alpha = 0
                            if destroy {
                                self?.destroy()
                            }
                        }
                )
            } else {
                alpha = 0
                if destroy {
                    self.destroy()
                }
            }
        }
    }
}

extension Presentation.UiKit {
    class VToastBottomView1: VToastView1 {
        public override func showView(animated: Bool) {
            if superview == nil {
                return
            }
            constraintToHide?.deactivate()
            constraintToShow?.activate()
            alpha = 0
            if animated {
                UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        options: UIView.AnimationOptions.curveEaseIn,
                        animations: { [weak self] in
                            self?.superview?.layoutIfNeeded()
                            self?.alpha = 1
                        },
                        completion: { [weak self] success in
                            if success {
                                self?.alpha = 1
                            }
                        }
                )
            } else {
                alpha = 1
            }
        }

        public override func hideView(animated: Bool, andDestroy destroy: Bool = false) {
            if superview == nil {
                return
            }
            constraintToShow?.deactivate()
            constraintToHide?.activate()
            alpha = 1
            if animated {
                UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        options: UIView.AnimationOptions.curveEaseOut,
                        animations: { [weak self] in
                            self?.superview?.layoutIfNeeded()
                            self?.alpha = 0
                        },
                        completion: { [weak self] success in
                            self?.alpha = 0
                            if destroy {
                                self?.destroy()
                            }
                        }
                )
            } else {
                alpha = 0
                if destroy {
                    self.destroy()
                }
            }
        }
    }
}

extension UIView {
    func showTopToast(
            text: String,
            type: Presentation.UiKit.VToastView1.ToastType = .default,
            customIcon: UIImage? = nil,
            ctaText: NSAttributedString? = nil,
            ctaAction: @escaping () -> Void,
            displayProperties: Presentation.UiKit.VToastView1.DisplayProperties = .default
    ) {
        let view = Presentation.UiKit.VToastTopView1(frame: .zero)
        view.tag = displayProperties.tag

        Self.attachTopToast(parent: self, child: view, displayProperties: displayProperties)
        view.hideView(animated: false)

        view.updateUi(
                text: text,
                type: type,
                customIcon: customIcon,
                ctaText: ctaText,
                ctaAction: ctaAction,
                displayProperties: displayProperties
        )
        layoutIfNeeded()
        view.showView(animated: displayProperties.animated)
    }

    func hideTopToast(tag: Int = Constants.TOAST_TOP_TAG) {
        subviews.filter({ $0.tag == tag })
                .forEach({
                    ($0 as? Presentation.UiKit.VToastTopView1)?.hideView(animated: true)
                    $0.removeFromSuperview()
                })
    }

    static func attachTopToast(
        parent: UIView,
        child: Presentation.UiKit.VToastView1,
        displayProperties: Presentation.UiKit.VToastView1.DisplayProperties
    ) {
        guard child.superview == nil else {
            return
        }
        var constraintToShow: Constraint?
        var constraintToHide: Constraint?

        parent.addSubview(child)
        child.snp.makeConstraints { (make: ConstraintMaker) in
            constraintToShow = make.top
                    .equalTo(parent.safeAreaLayoutGuide)
                    .offset(displayProperties.showSpace)
                    .priority(999)
                    .constraint
            constraintToHide = make.bottom
                    .equalTo(parent.safeAreaLayoutGuide.snp.top)
                    .offset(-16)
                    .constraint
            make.leading
                    .greaterThanOrEqualToSuperview()
                    .offset(16)
            make.centerX
                    .equalToSuperview()

            if UIDevice.current.userInterfaceIdiom == .pad,
                let maxWidthPad = displayProperties.maxWidthPad {
                make.width
                        .lessThanOrEqualTo(maxWidthPad)
            } else if UIDevice.current.userInterfaceIdiom == .phone,
                     let maxWidthPhone = displayProperties.maxWidthPhone {
                make.width
                        .lessThanOrEqualTo(maxWidthPhone)
            }
        }

        constraintToShow?.deactivate()

        child.constraintToShow = constraintToShow
        child.constraintToHide = constraintToHide
    }
}

extension UIView {
    func showBottomToast(
            text: String,
            type: Presentation.UiKit.VToastView1.ToastType = .default,
            customIcon: UIImage? = nil,
            ctaText: NSAttributedString? = nil,
            ctaAction: @escaping () -> Void,
            displayProperties: Presentation.UiKit.VToastView1.DisplayProperties = .default
    ) {
        let view = Presentation.UiKit.VToastBottomView1(frame: .zero)
        view.tag = displayProperties.tag

        Self.attachBottomToast(parent: self, child: view, displayProperties: displayProperties)
        view.hideView(animated: false)

        view.updateUi(
                text: text,
                type: type,
                customIcon: customIcon,
                ctaText: ctaText,
                ctaAction: ctaAction,
                displayProperties: displayProperties
        )
        layoutIfNeeded()
        view.showView(animated: displayProperties.animated)
    }

    func hideBottomToast(tag: Int = Constants.TOAST_BOTTOM_TAG) {
        subviews.filter({ $0.tag == tag })
                .forEach({
                    ($0 as? Presentation.UiKit.VToastBottomView1)?.hideView(animated: true)
                    $0.removeFromSuperview()
                })
    }

    static func attachBottomToast(
        parent: UIView,
        child: Presentation.UiKit.VToastBottomView1,
        displayProperties: Presentation.UiKit.VToastView1.DisplayProperties
    ) {
        guard child.superview == nil else {
            return
        }
        var constraintToShow: Constraint?
        var constraintToHide: Constraint?

        parent.addSubview(child)
        child.snp.makeConstraints { (make: ConstraintMaker) in
            constraintToShow = make.bottom
                    .equalTo(parent.safeAreaLayoutGuide)
                    .offset(-displayProperties.showSpace)
                    .priority(999)
                    .constraint
            constraintToHide = make.top
                    .equalTo(parent.safeAreaLayoutGuide.snp.bottom)
                    .offset(16)
                    .constraint
            make.leading
                    .greaterThanOrEqualToSuperview()
                    .offset(16)
            make.centerX
                    .equalToSuperview()

            if UIDevice.current.userInterfaceIdiom == .pad,
                let maxWidthPad = displayProperties.maxWidthPad {
                make.width
                        .lessThanOrEqualTo(maxWidthPad)
            } else if UIDevice.current.userInterfaceIdiom == .phone,
                     let maxWidthPhone = displayProperties.maxWidthPhone {
                make.width
                        .lessThanOrEqualTo(maxWidthPhone)
            }
        }

        constraintToShow?.deactivate()

        child.constraintToShow = constraintToShow
        child.constraintToHide = constraintToHide
    }
}


extension Presentation {
    enum KingfisherHelper {
    }
}

extension Presentation.KingfisherHelper {
    enum GenieClass {
        public static let recordedHeaderThumbnail = ImageCache(name: "genie_class_recorded_header_thumbnail")
        public static let recordedHeaderOriginal = ImageCache(name: "genie_class_recorded_header_original")
        public static let recordedDownsampling = DownsamplingImageProcessor(size: CGSize(width: 320, height: 160))
        public static let recordedHeaderOptions: [KingfisherOptionsInfoItem] = [
            .targetCache(recordedHeaderThumbnail),
            .originalCache(recordedHeaderOriginal),
            .processor(recordedDownsampling),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .downloadPriority(URLSessionTask.lowPriority),
            .retryStrategy(DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(3))),
            .cacheOriginalImage
        ]
    }
}

// swiftlint:enable all
