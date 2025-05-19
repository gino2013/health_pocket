//
//  UserDefaults+helpers.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import Foundation

/// `WorkAndRestTimeSettings` 結構體儲存了用戶的工作和休息時間設定。
///
/// - Properties:
///   - breakfast: 早餐時間，例如 "08:00"
///   - lunch: 午餐時間，例如 "12:00"
///   - dinner: 晚餐時間，例如 "18:00"
///   - bedtime: 睡覺時間，例如 "21:30"
struct WorkAndRestTimeSettings: Codable {
    let breakfast: String  // 早餐時間，格式為 "HH:mm"
    let lunch: String      // 午餐時間，格式為 "HH:mm"
    let dinner: String     // 晚餐時間，格式為 "HH:mm"
    let bedtime: String    // 睡覺時間，格式為 "HH:mm"
}

/// `ReminderTimeSetting` 結構體儲存了用戶在用餐前、後及睡前的提醒時間設定。
///
/// - Properties:
///   - beforeMeal: 用餐前提醒的時間（以分鐘為單位）
///   - afterMeal: 用餐後提醒的時間（以分鐘為單位）
///   - beforeBed: 睡前提醒的時間（以分鐘為單位）
struct ReminderTimeSetting: Codable {
    let beforeMeal: Int  // 用餐前提醒時間（分鐘）
    let afterMeal: Int   // 用餐後提醒時間（分鐘）
    let beforeBed: Int   // 睡前提醒時間（分鐘）
}

/// `UserDefaults` 的擴展，增加了與應用設定相關的保存與讀取方法。
extension UserDefaults {
    
    /// 定義了一組與 `UserDefaults` 鍵相關的枚舉。
    enum UserDefaultsKeys: String {
        case isLoggedIn                // 是否已登錄
        case hasViewedWalkthrough      // 是否已查看引導頁
        case refreshTokenTimeKey       // 刷新 Token 的時間
        case hasViewedPromotion        // 是否已查看促銷信息
        case threadMutex               // 用於線程鎖
        case startOTPVerifySMSTime      // OTP 驗證的開始時間
        case isFirstLogin              // 是否為首次登錄
        case enableFaceId              // 是否啟用 Face ID
        case isSaveMe                  // 是否啟用了 "記住我" 功能
        case durationInSecond          // idToken 的持續時間（以秒為單位）
    }
    
    /// 設置用戶登錄狀態。
    ///
    /// - Parameter value: 布爾值，表示是否已登錄。
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    /// 獲取用戶的登錄狀態。
    ///
    /// - Returns: 布爾值，表示是否已登錄。
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    /// 設置用戶是否已查看引導頁。
    ///
    /// - Parameter value: 布爾值，表示是否已查看引導頁。
    func setHasViewedWalkthrough(value: Bool) {
        set(value, forKey: UserDefaultsKeys.hasViewedWalkthrough.rawValue)
        synchronize()
    }
    
    /// 獲取用戶是否已查看引導頁。
    ///
    /// - Returns: 布爾值，表示是否已查看引導頁。
    func isHasViewedWalkthrough() -> Bool {
        return bool(forKey: UserDefaultsKeys.hasViewedWalkthrough.rawValue)
    }
    
    /// 設置刷新 Token 的時間。
    ///
    /// - Parameter value: `NSDate` 對象，表示刷新 Token 的時間。
    func setRefreshTokenTimeKey(value: NSDate) {
        set(value, forKey: UserDefaultsKeys.refreshTokenTimeKey.rawValue)
        synchronize()
    }
    
    /// 獲取刷新 Token 的時間。
    ///
    /// - Returns: 可選的 `NSDate` 對象，表示刷新 Token 的時間。
    func getRefreshTokenTimeKey() -> NSDate? {
        return object(forKey: UserDefaultsKeys.refreshTokenTimeKey.rawValue) as? NSDate
    }
    
    /// 設置用戶是否已查看促銷信息。
    ///
    /// - Parameter value: 布爾值，表示是否已查看促銷信息。
    func setHasViewedPromotion(value: Bool) {
        set(value, forKey: UserDefaultsKeys.hasViewedPromotion.rawValue)
        synchronize()
    }
    
    /// 獲取用戶是否已查看促銷信息。
    ///
    /// - Returns: 布爾值，表示是否已查看促銷信息。
    func isHasViewedPromotion() -> Bool {
        return bool(forKey: UserDefaultsKeys.hasViewedPromotion.rawValue)
    }
    
    /// 設置線程鎖狀態。
    ///
    /// - Parameter lock: 布爾值，表示線程是否已鎖定。
    func setThreadMutex(lock: Bool) {
        set(lock, forKey: UserDefaultsKeys.threadMutex.rawValue)
        synchronize()
    }
    
    /// 獲取線程鎖狀態。
    ///
    /// - Returns: 布爾值，表示線程是否已鎖定。
    func isThreadMutex() -> Bool {
        return bool(forKey: UserDefaultsKeys.threadMutex.rawValue)
    }
    
    /// 設置 OTP 驗證的開始時間。
    ///
    /// - Parameter value: `Date` 對象，表示 OTP 驗證的開始時間。
    func setStartOTPVerifySMSTime(value: Date) {
        set(value, forKey: UserDefaultsKeys.startOTPVerifySMSTime.rawValue)
        synchronize()
    }
    
    /// 獲取 OTP 驗證的開始時間。
    ///
    /// - Returns: 可選的 `Date` 對象，表示 OTP 驗證的開始時間。
    func getStartOTPVerifySMSTime() -> Date? {
        return object(forKey: UserDefaultsKeys.startOTPVerifySMSTime.rawValue) as? Date
    }
    
    /// 清除保存的 OTP 驗證開始時間。
    func clearStartCryptoOTPVerifySMSTime() {
        removeObject(forKey: UserDefaultsKeys.startOTPVerifySMSTime.rawValue)
        synchronize()
    }
    
    /// 設置是否為首次登錄。
    ///
    /// - Parameter value: 布爾值，表示是否為首次登錄。
    func setIsFirstLogin(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isFirstLogin.rawValue)
        synchronize()
    }
    
    /// 獲取是否為首次登錄。
    ///
    /// - Returns: 可選的布爾值，表示是否為首次登錄。
    func isFirstLogin() -> Bool? {
        return object(forKey: UserDefaultsKeys.isFirstLogin.rawValue) as? Bool
    }
    
    /// 設置是否啟用 Face ID。
    ///
    /// - Parameter value: 布爾值，表示是否啟用 Face ID。
    func setEnableFaceId(value: Bool) {
        set(value, forKey: UserDefaultsKeys.enableFaceId.rawValue)
        synchronize()
    }
    
    /// 獲取是否啟用 Face ID。
    ///
    /// - Returns: 布爾值，表示是否啟用 Face ID。
    func isEnableFaceId() -> Bool {
        return bool(forKey: UserDefaultsKeys.enableFaceId.rawValue)
    }
    
    /// 設置 "記住我" 功能的狀態。
    ///
    /// - Parameter value: 布爾值，表示是否啟用 "記住我" 功能。
    func setIsSaveMe(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isSaveMe.rawValue)
        synchronize()
    }
    
    /// 獲取 "記住我" 功能的狀態。
    ///
    /// - Returns: 布爾值，表示是否啟用 "記住我" 功能。
    func isSaveMe() -> Bool {
        return bool(forKey: UserDefaultsKeys.isSaveMe.rawValue)
    }
    
    /// 設置 idToken 的持續時間（以秒為單位）。
    ///
    /// - Parameter value: `Int` 型數字，表示持續時間（秒）。
    func setDurationInSecond(value: Int) {
        set(value, forKey: UserDefaultsKeys.durationInSecond.rawValue)
        synchronize()
    }
    
    /// 獲取 idToken 的持續時間（以秒為單位）。
    ///
    /// - Returns: 可選的 `Int`，表示持續時間（秒）。
    func getDurationInSecond() -> Int? {
        return object(forKey: UserDefaultsKeys.durationInSecond.rawValue) as? Int
    }
    
    /// 保存用戶的工作和休息時間設定。
    ///
    /// - Parameter settings: `WorkAndRestTimeSettings` 對象，包含用戶的工作和休息時間設定。
    func saveWorkAndRestTimeSettings(_ settings: WorkAndRestTimeSettings) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "workAndRestTimeSettingsKey")
        }
    }
    
    /// 加載用戶的工作和休息時間設定。
    ///
    /// - Returns: 可選的 `WorkAndRestTimeSettings` 對象，包含用戶的工作和休息時間設定。
    func loadWorkAndRestTimeSettings() -> WorkAndRestTimeSettings? {
        if let savedSettings = UserDefaults.standard.object(forKey: "workAndRestTimeSettingsKey") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(WorkAndRestTimeSettings.self, from: savedSettings) {
                return loadedSettings
            }
        }
        return nil
    }
    
    /// 保存用戶的提醒時間設定。
    ///
    /// - Parameter settings: `ReminderTimeSetting` 對象，包含用戶的提醒時間設定。
    func saveReminderTimeSetting(_ settings: ReminderTimeSetting) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "reminderTimeSetting")
        }
    }
    
    /// 加載用戶的提醒時間設定。
    ///
    /// - Returns: 可選的 `ReminderTimeSetting` 對象，包含用戶的提醒時間設定。
    func loadReminderTimeSetting() -> ReminderTimeSetting? {
        if let savedSettings = UserDefaults.standard.object(forKey: "reminderTimeSetting") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(ReminderTimeSetting.self, from: savedSettings) {
                return loadedSettings
            }
        }
        return nil
    }
    
    /// 刪除用戶的工作和休息時間設定。
    func clearWorkAndRestTimeSettings() {
        removeObject(forKey: "workAndRestTimeSettingsKey")
    }
    
    /// 刪除用戶的提醒時間設定。
    func clearReminderTimeSetting() {
        removeObject(forKey: "reminderTimeSetting")
    }
}
