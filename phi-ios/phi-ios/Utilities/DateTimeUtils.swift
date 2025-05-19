//
//  DateTimeUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import Foundation
import UIKit

/// `DateTimeUtils` 類別包含了一組與日期和時間相關的實用方法。
class DateTimeUtils {
    
    /// 比較給定時間與當前時間的差異。
    ///
    /// - Parameter givenDate: 給定時間的毫秒數（自1970年以來）。
    /// - Returns: 給定時間與當前時間的時間間隔，以秒為單位。
    class func compareGivenTimeAndNow(givenDate: Double) -> TimeInterval {
        let realTotalTime = DateTimeUtils.convertMilliSecondsToDate(givenDate)
        let givenDate = realTotalTime.timeIntervalSince1970
        let nowDate = NSDate().timeIntervalSince1970
        return (givenDate - nowDate)
    }
    
    /// 將毫秒轉換為 `Date` 物件。
    ///
    /// - Parameter milliseconds: 毫秒數（自1970年以來）。
    /// - Returns: 對應的 `Date` 物件。
    class func convertMilliSecondsToDate(_ milliseconds: Double) -> Date {
        let utcDate = Date(timeIntervalSince1970: milliseconds / 1000)
        return utcDate
    }
    
    /// 將 `Date` 物件轉換為毫秒數的字符串格式。
    ///
    /// - Parameter date: 要轉換的 `Date` 物件。
    /// - Returns: 毫秒數的字符串格式。
    class func convertDateToMillisecondsString(_ date: Date) -> String {
        return String(format: "%.0f", floor(date.timeIntervalSince1970 * 1000))
    }
    
    /// 將倒計時的時間間隔轉換為 `HH:mm:ss` 格式的字符串。
    ///
    /// - Parameter countDownTime: 倒計時的時間間隔，以秒為單位。
    /// - Returns: 格式化的字符串，表示為 `HH:mm:ss`。
    class func stringFromCountDownTime(_ countDownTime: TimeInterval) -> String {
        let tmpTime: TimeInterval = countDownTime * 1000
        let seconds: Int = Int(tmpTime.truncatingRemainder(dividingBy: 60))
        let minutes: Int = Int((tmpTime / 60).truncatingRemainder(dividingBy: 60))
        let hours: Int = Int(tmpTime / 60 / 60)
        
        return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
    }
    
    /// 取得從今天開始，往前和往後若干天的日期字符串陣列。
    ///
    /// - Parameter days: 要取得的日期範圍，表示天數。
    /// - Returns: 包含日期字符串的陣列，格式為 `yyyy-MM-dd`。
    class func dateStrings(_ days: Int) -> [String] {
        var items = [String]()
        let oneDayTime: TimeInterval = 24 * 60 * 60
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<days {
            let tmp: TimeInterval = Double(i) * oneDayTime
            let dayToToday = Date().addingTimeInterval(-tmp)
            let dateStr = dateFormatter.string(from: dayToToday)
            items.append(dateStr)
        }
        return items
    }
    
    /// 獲取今天的日期字符串，格式為 `yyyy-MM-dd`。
    ///
    /// - Returns: 今天的日期字符串。
    class func today() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    /// 獲取當前年份的字符串格式。
    ///
    /// - Returns: 當前年份的字符串，格式為 `yyyy`。
    class func getCurrentYear() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return String(format: "%04d", arguments: [year])
    }
    
    /// 將秒數轉換為小時、分鐘和秒數的元組格式。
    ///
    /// - Parameter seconds: 總秒數。
    /// - Returns: 包含小時、分鐘和秒數的元組 `(Int, Int, Int)`。
    class func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    /// 將秒數轉換為分鐘和秒數的元組格式。
    ///
    /// - Parameter seconds: 總秒數。
    /// - Returns: 包含分鐘和秒數的元組 `(Int, Int)`。
    class func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    /// 打印將秒數轉換為小時、分鐘和秒數的結果。
    ///
    /// - Parameter seconds: 總秒數。
    class func printSecondsToHoursMinutesSeconds(seconds: Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
        print ("\(h)Hours, \(m)Minutes, \(s)Seconds")
    }
    
    /// 計算從給定日期開始，往前和往後若干天的日期範圍。
    ///
    /// - Parameters:
    ///   - date: 起始日期的字符串，格式為 `yyyy/MM/dd`。
    ///   - daysBefore: 往前推算的天數。
    ///   - daysAfter: 往後推算的天數。
    /// - Returns: 包含日期字符串的陣列。
    static func getDateRange(from date: String, daysBefore: Int, daysAfter: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        guard let startDate = dateFormatter.date(from: date) else {
            return []
        }
        
        var dateRange: [String] = []
        let calendar = Calendar.current
        
        for day in (-daysBefore...0).reversed() {
            if let newDate = calendar.date(byAdding: .day, value: day, to: startDate) {
                let dateString = dateFormatter.string(from: newDate)
                dateRange.append(dateString)
            }
        }
        
        for day in 1...daysAfter {
            if let newDate = calendar.date(byAdding: .day, value: day, to: startDate) {
                let dateString = dateFormatter.string(from: newDate)
                dateRange.append(dateString)
            }
        }
        
        return dateRange
    }
    
    /// 計算從給定日期開始，往前和往後若干天的日期範圍，返回起始和結束日期。
    ///
    /// - Parameters:
    ///   - date: 起始日期的字符串，格式為 `yyyy/MM/dd`。
    ///   - daysBefore: 往前推算的天數。
    ///   - daysAfter: 往後推算的天數。
    /// - Returns: 包含起始和結束日期的元組，若日期格式錯誤則返回 `nil`。
    static func getDateRange(from date: String, daysBefore: Int, daysAfter: Int) -> (startDate: String, endDate: String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        guard let startDate = dateFormatter.date(from: date) else {
            return nil
        }
        
        let calendar = Calendar.current
        
        guard let firstDate = calendar.date(byAdding: .day, value: -daysBefore, to: startDate) else {
            return nil
        }
        
        guard let lastDate = calendar.date(byAdding: .day, value: daysAfter, to: startDate) else {
            return nil
        }
        
        let startDateString = dateFormatter.string(from: firstDate)
        let endDateString = dateFormatter.string(from: lastDate)
        
        return (startDateString, endDateString)
    }
    
    /// 判斷某個日期是否在給定的日期範圍內。
    ///
    /// - Parameters:
    ///   - dateString: 要判斷的日期字符串，格式為 `yyyy/MM/dd`。
    ///   - startDateString: 範圍的起始日期字符串，格式為 `yyyy/MM/dd`。
    ///   - endDateString: 範圍的結束日期字符串，格式為 `yyyy/MM/dd`。
    /// - Returns: 如果日期在範圍內，返回 `true`；如果不在範圍內，返回 `false`；如果日期格式錯誤，返回 `nil`。
    static func isDateInRange(dateString: String, startDateString: String, endDateString: String) -> Bool? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        guard let date = dateFormatter.date(from: dateString),
              let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        return date >= startDate && date <= endDate
    }
    
    /// 比較提醒時間是否已經過去。
    ///
    /// - Parameters:
    ///   - reminderDate: 提醒的日期字符串，格式為 `yyyy/MM/dd`。
    ///   - reminderTime: 提醒的時間字符串，格式為 `HH:mm:ss`。
    /// - Returns: 如果當前時間已經超過提醒時間，返回 `true`，否則返回 `false`。
    static func isReminderPassed(reminderDate: String, reminderTime: String) -> Bool {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let reminderDateTimeString = "\(reminderDate) \(reminderTime)"
        
        guard let reminderDateTime = dateTimeFormatter.date(from: reminderDateTimeString) else {
            return false
        }
        
        let currentDateTime = Date()
        
        return currentDateTime > reminderDateTime
    }
    
    /// 比較給定的提醒時間是否已經過去。
    ///
    /// - Parameter remindDateTime: 提醒的日期和時間字符串，格式為 `yyyy/MM/dd HH:mm:ss`。
    /// - Returns: 如果提醒時間已經過去，返回 `true`，否則返回 `false`。
    static func isReminderTimePassed(remindDateTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let reminderDate = dateFormatter.date(from: remindDateTime) else {
            print("Warning! Unknown time format!")
            return false
        }
        
        let currentDate = Date()
        
        return reminderDate < currentDate
    }
    
    /// 將 `Date` 物件轉換為指定格式的時間字符串。
    ///
    /// - Parameters:
    ///   - srcDate: 要轉換的 `Date` 物件。
    ///   - formate: 格式化字符串，默認為 `yyyy/MM/dd`。
    /// - Returns: 格式化的時間字符串。
    static func convertDateToTimeString(srcDate: Date, formate: String = "yyyy/MM/dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: srcDate)
    }
    
    /// 將日期字符串轉換為 `Date` 物件。
    ///
    /// - Parameters:
    ///   - dateString: 日期字符串。
    ///   - format: 格式化字符串，默認為 `yyyy/MM/dd`。
    /// - Returns: 對應的 `Date` 物件，如果轉換失敗則返回當前日期。
    static func convertStringToDate(dateString: String, format: String = "yyyy/MM/dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    /// 判斷給定日期是否在今天之前。
    ///
    /// - Parameters:
    ///   - dateString: 要判斷的日期字符串。
    ///   - format: 日期格式，默認為 `yyyy/MM/dd`。
    /// - Returns: 如果日期在今天之前，返回 `true`，否則返回 `false`；如果日期格式錯誤，返回 `nil`。
    static func isDateBeforeToday(dateString: String, format: String = "yyyy/MM/dd") -> Bool? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        let startOfDayToday = calendar.startOfDay(for: Date())
        let startOfDayDate = calendar.startOfDay(for: date)
        
        return startOfDayDate < startOfDayToday
    }
    
    /// 判斷給定日期是否在今天之後。
    ///
    /// - Parameters:
    ///   - dateString: 要判斷的日期字符串。
    ///   - format: 日期格式，默認為 `yyyy/MM/dd`。
    /// - Returns: 如果日期在今天之後，返回 `true`，否則返回 `false`；如果日期格式錯誤，返回 `nil`。
    static func isDateAfterToday(dateString: String, format: String = "yyyy/MM/dd") -> Bool? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        let startOfDayToday = calendar.startOfDay(for: Date())
        let startOfDayDate = calendar.startOfDay(for: date)
        
        return startOfDayDate > startOfDayToday
    }
    
    /// 設置 UIDatePicker 的時間為指定的時間字符串。
    ///
    /// - Parameters:
    ///   - time: 時間字符串，格式為 `HH:mm`。
    ///   - srcTimePicker: 要設置時間的 UIDatePicker 物件。
    ///   - diplayFormat: 顯示格式，默認為 `HH:mm`。
    static func setDefaultTimes(time: String, srcTimePicker: UIDatePicker, diplayFormat: String = "HH:mm") {
        let timeWithoutSeconds = String(time.prefix(5))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = diplayFormat
        
        guard let date = dateFormatter.date(from: timeWithoutSeconds) else {
            fatalError("Unknown Time Format!")
        }
        srcTimePicker.date = date
    }
    
    /// 將 `Date` 物件轉換為 `yyyy-MM-dd` 格式的字符串。
    ///
    /// - Parameter date: 要轉換的 `Date` 物件。
    /// - Returns: 格式化的日期字符串。
    static func convertDateToYearMonthDayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    /// 比較兩個 `Date` 物件是否相同，僅比較年、月、日部分。
    ///
    /// - Parameters:
    ///   - date1: 第一個 `Date` 物件。
    ///   - date2: 第二個 `Date` 物件。
    /// - Returns: 如果年、月、日相同，返回 `true`，否則返回 `false`。
    static func compareDatesByYearMonthDay(date1: Date, date2: Date) -> Bool {
        let dateString1 = convertDateToYearMonthDayString(date: date1)
        let dateString2 = convertDateToYearMonthDayString(date: date2)
        return dateString1 < dateString2
    }
}
