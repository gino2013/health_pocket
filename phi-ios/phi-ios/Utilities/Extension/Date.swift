//
//  DateUTC.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/26.
//

import Foundation
import UIKit

extension Date {

    /// 返回從指定日期開始計算的秒數。
    /// - Parameter from: 要比較的日期。
    /// - Returns: 兩個日期之間的秒數，作為 `Int` 返回。
    func countSeconds(from: Date) -> Int {
        let diff = timeIntervalSince(from)
        return Int(diff)
    }

    /// 檢查當前日期是否在兩個指定日期之間。
    /// - Parameters:
    ///   - date1: 起始日期。
    ///   - date2: 結束日期。
    /// - Returns: 如果當前日期在範圍內返回 `true`，否則返回 `false`。
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return self >= date1 && self <= date2
    }

    /// 將當前日期從一個時區轉換到另一個時區。
    /// - Parameters:
    ///   - initTimeZone: 原始時區。
    ///   - targetTimeZone: 目標時區。
    /// - Returns: 轉換後的 `Date` 對象。
    func convert(from initTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(initTimeZone.secondsFromGMT() - targetTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }

    /// 自1970年以來的毫秒數（Unix時間戳）。
    var millisecondsSince1970: Int {
        return Int((Date().timeIntervalSince1970 * 1000.0).rounded())
    }

    /// 使用提供的毫秒數初始化 `Date` 對象。
    /// - Parameter milliseconds: 自1970年以來的毫秒數，`Int64` 類型。
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    /// 以字符串形式返回當前日期的月份中的日期（例如："01", "02"）。
    /// - Returns: 返回月份中的日期，格式為大寫字母的字符串。
    func dayOfMonth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期的星期幾（縮寫，如："Mon", "Tue"）。
    /// - Returns: 返回星期幾，格式為大寫字母的字符串。
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期的月份（縮寫，如："Jan", "Feb"）。
    /// - Returns: 返回月份，格式為大寫字母的字符串。
    func monthOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期的完整月份名稱（例如："January", "February"）。
    /// - Returns: 返回完整月份名稱，格式為大寫字母的字符串。
    func fullMonthOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期的年份。
    /// - Returns: 返回年份，格式為大寫字母的字符串。
    func yearNum() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期在星期中的日期號碼（例如："01", "02"）。
    /// - Returns: 返回日期號碼，格式為大寫字母的字符串。
    func dayNumOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self).capitalized
    }

    /// 以字符串形式返回當前日期的月份號碼（例如："01", "02"）。
    /// - Returns: 返回月份號碼，格式為大寫字母的字符串。
    func monthNumOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self).capitalized
    }

    /// 返回當前日期在 UTC 時區的日期。
    /// - Returns: 一個表示當前日期在 UTC 時區的 `Date` 對象。
    func currentUTCTimeZoneDate() -> Date {
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dtf.date(from: dtf.string(from: self))!
    }

    /// 使用給定的格式將日期字符串轉換為 `Date` 對象。
    /// - Parameters:
    ///   - strDate: 要轉換的日期字符串。
    ///   - strFormate: 日期字符串的格式。
    /// - Returns: 一個表示提供的日期字符串的 `Date` 對象。
    func convertStringToDate(strDate: String, dateFormate strFormate: String) -> Date {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = strFormate
        dateFormate.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormate.date(from: strDate)!
    }

    /// 將日期字符串從 UTC 時區轉換為本地時區。
    /// - Parameters:
    ///   - strDate: 要轉換的日期字符串。
    ///   - strOldFormate: 日期字符串的舊格式。
    ///   - strNewFormate: 日期字符串的新格式。
    /// - Returns: 表示本地時區中日期的字符串。
    static func convertDateUTCToLocal(strDate: String, oldFormate strOldFormate: String, newFormate strNewFormate: String) -> String {
        let dateFormatterUTC = DateFormatter()
        dateFormatterUTC.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        dateFormatterUTC.dateFormat = strOldFormate
        if let oldDate = dateFormatterUTC.date(from: strDate) {
            dateFormatterUTC.timeZone = NSTimeZone.local
            dateFormatterUTC.dateFormat = strNewFormate
            return dateFormatterUTC.string(from: oldDate)
        }
        return strDate
    }

    /// 在不使用 UTC 的情況下將日期字符串轉換為本地時區日期字符串。
    /// - Parameters:
    ///   - strDate: 要轉換的日期字符串。
    ///   - strOldFormate: 日期字符串的舊格式。
    ///   - strNewFormate: 日期字符串的新格式。
    /// - Returns: 表示本地時區中日期的字符串。
    func convertDateToLocal(strDate: String, oldFormate strOldFormate: String, newFormate strNewFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strOldFormate
        if let oldDate = dateFormatter.date(from: strDate) {
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = strNewFormate
            return dateFormatter.string(from: oldDate)
        }
        return strDate
    }

    /// 使用指定格式將當前日期轉換為字符串。
    /// - Parameter strDateFormate: 所需的日期格式。
    /// - Returns: 返回當前日期的字符串，格式根據提供的格式。
    func convertDateToString(strDateFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormate
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    /// 返回當前日期的下一天。
    /// - Returns: 一個 `Date` 對象，表示下一天的日期。
    func getNextDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }

    /// 返回當前日期的前一天。
    /// - Returns: 一個 `Date` 對象，表示前一天的日期。
    func getPreviousDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }

    /// 返回當前日期的下個月。
    /// - Returns: 一個 `Date` 對象，表示下個月的日期。
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    /// 返回當前日期的上個月。
    /// - Returns: 一個 `Date` 對象，表示上個月的日期。
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }

    /// 返回當前月份的天數。
    /// - Returns: 當前月份的天數，作為 `Int` 返回。
    func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }

    /// 將日期字符串從本地時區轉換為 UTC 時區。
    /// - Parameters:
    ///   - strDate: 要轉換的日期字符串。
    ///   - strOldFormate: 日期字符串的舊格式。
    ///   - strNewFormate: 日期字符串的新格式。
    /// - Returns: 表示 UTC 時區中日期的字符串。
    static func convertLocalToUTC(strDate: String, oldFormate strOldFormate: String, newFormate strNewFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local as TimeZone?
        dateFormatter.dateFormat = strOldFormate
        if let oldDate = dateFormatter.date(from: strDate) {
            dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")! as TimeZone
            dateFormatter.dateFormat = strNewFormate
            return dateFormatter.string(from: oldDate)
        }
        return strDate
    }

    /// 比較兩個日期並返回描述結果的字符串。
    /// - Parameters:
    ///   - date: 要比較的第一個日期。
    ///   - compareDate: 要比較的第二個日期。
    /// - Returns: 一個字符串，描述日期是過去、未來還是相同。
    static func compare(date: Date, compareDate: Date) -> String {
        let result: ComparisonResult = date.compare(compareDate)
        switch result {
        case .orderedAscending:
            return "未來的日期"
        case .orderedDescending:
            return "過去的日期"
        case .orderedSame:
            return "相同的日期"
        }
    }

    /// 返回從指定日期開始計算的年數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的年數，作為 `Int` 返回。
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// 返回從指定日期開始計算的月數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的月數，作為 `Int` 返回。
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// 返回從指定日期開始計算的週數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的週數，作為 `Int` 返回。
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// 返回從指定日期開始計算的天數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的天數，作為 `Int` 返回。
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// 返回從指定日期開始計算的小時數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的小時數，作為 `Int` 返回。
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// 返回從指定日期開始計算的分鐘數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的分鐘數，作為 `Int` 返回。
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// 返回從指定日期開始計算的秒數。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 兩個日期之間的秒數，作為 `Int` 返回。
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// 返回從指定日期開始計算的時間間隔描述。
    /// - Parameter date: 要比較的日期。
    /// - Returns: 一個字符串，表示時間差。
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }

    /// 返回表示日期距今時間的友好字符串。
    /// - Returns: 一個字符串，表示日期距今的時間差。
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = calendar.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) 秒"
        } else if hourAgo < self {
            let diff = calendar.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) 分鐘"
        } else if dayAgo < self {
            let diff = calendar.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) 小時"
        } else if weekAgo < self {
            let diff = calendar.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) 天"
        }
        let diff = calendar.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) 週"
    }
}
