//
//  RealmManager.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/14.
//

import Foundation
//import RealmSwift

/*
// 用于存储药物信息
class RealmReminderMedicineInfo: Object {
    @objc dynamic var medicineName = ""
    @objc dynamic var medicineNameAlias = ""
    @objc dynamic var dose: Double = 0.0
    @objc dynamic var doseUnits = ""
    @objc dynamic var useTime = ""
}

// 用于存储提醒记录中的药物信息
class RealmReminderRecordMedicine: Object {
    @objc dynamic var reminderRecordMedicineInfoId = 0
    @objc dynamic var takenTime = ""
    
    override static func primaryKey() -> String? {
        return "reminderRecordMedicineInfoId"
    }
}

// 用于存储单个提醒的信息
class RealmReminder: Object {
    @objc dynamic var type = ""
    @objc dynamic var isSingleTimeSetting = false
    @objc dynamic var reminderDate = ""
    @objc dynamic var reminderTime = ""
    @objc dynamic var reminderSettingId = 0
    @objc dynamic var reminderTimeSettingId = 0
    @objc dynamic var reminderSingleTimeSettingId = 0
    @objc dynamic var isChecked = false
    @objc dynamic var checkTime = ""
    @objc dynamic var isEnded = false
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    var tags = List<String>()
    
    @objc dynamic var reminderRecordMedicineInfo: RealmReminderRecordMedicine?
    @objc dynamic var reminderSettingMedicineInfo: RealmReminderMedicineInfo?
}

// 用于存储时间段分组
class RealmReminderTimeGroup: Object {
    @objc dynamic var timeTitle = ""
    let items = List<RealmReminder>()
}

// 用于存储日期分组
class RealmReminderRecordGroup: Object {
    @objc dynamic var date = ""
    let timeGroups = List<RealmReminderTimeGroup>()
    
    override static func primaryKey() -> String? {
        return "date"
    }
}

// ReminderNotificationDataManager.shared.setCacheDuration(7200) // 將快取時間設為 2 小時
// ReminderNotificationDataManager.shared.setUseCache(false) // 關閉快取，直接使用 API
class ReminderNotificationDataManager {
    
    static let shared = ReminderNotificationDataManager()
    
    // private let realm = try! Realm()
    private var cacheDuration: TimeInterval = 3600 // 默认缓存时间为 1 小时
    private var lastFetchTime: Date?
    private var useCache: Bool = false
    
    private init() { }
    
    // 调整缓存时间
    func setCacheDuration(_ duration: TimeInterval) {
        cacheDuration = duration
    }
    
    // Getter 和 Setter 方法
    func getLastFetchTime() -> Date? {
        return lastFetchTime
    }
    
    func setLastFetchTime(_ date: Date) {
        lastFetchTime = date
    }
    
    // 设置是否使用 Realm 缓存
    func setUseCache(_ useCache: Bool) {
        self.useCache = useCache
    }
    
    // 保存提醒记录到 Realm
    func saveReminders(reminderRecords: [(date: String, timeGroups: [ReminderTimeGroupRspModel])]) {
        let realmRecords = reminderRecords.map { record in
            let realmTimeGroups = record.timeGroups.map { timeGroup in
                let realmItems = timeGroup.items.map { item in
                    let realmReminder = RealmReminder()
                    realmReminder.type = item.type
                    realmReminder.isSingleTimeSetting = item.isSingleTimeSetting
                    realmReminder.reminderDate = item.reminderDate
                    realmReminder.reminderTime = item.reminderTime
                    realmReminder.reminderSettingId = item.reminderSettingId
                    realmReminder.reminderTimeSettingId = item.reminderTimeSettingId
                    realmReminder.reminderSingleTimeSettingId = item.reminderSingleTimeSettingId
                    realmReminder.isChecked = item.isChecked
                    realmReminder.checkTime = item.checkTime
                    realmReminder.isEnded = item.isEnded
                    realmReminder.title = item.title
                    realmReminder.subTitle = item.subTitle
                    realmReminder.tags.append(objectsIn: item.tags)
                    
                    let realmRecordMedicineInfo = RealmReminderRecordMedicine()
                    realmRecordMedicineInfo.reminderRecordMedicineInfoId = item.reminderRecordMedicineInfo.reminderRecordMedicineInfoId
                    realmRecordMedicineInfo.takenTime = item.reminderRecordMedicineInfo.takenTime
                    realmReminder.reminderRecordMedicineInfo = realmRecordMedicineInfo
                    
                    let realmSettingMedicineInfo = RealmReminderMedicineInfo()
                    realmSettingMedicineInfo.medicineName = item.reminderSettingMedicineInfo.medicineName
                    realmSettingMedicineInfo.medicineNameAlias = item.reminderSettingMedicineInfo.medicineNameAlias
                    realmSettingMedicineInfo.dose = item.reminderSettingMedicineInfo.dose
                    realmSettingMedicineInfo.doseUnits = item.reminderSettingMedicineInfo.doseUnits
                    realmSettingMedicineInfo.useTime = item.reminderSettingMedicineInfo.useTime
                    realmReminder.reminderSettingMedicineInfo = realmSettingMedicineInfo
                    
                    return realmReminder
                }
                let realmTimeGroup = RealmReminderTimeGroup()
                realmTimeGroup.timeTitle = timeGroup.timeTitle
                realmTimeGroup.items.append(objectsIn: realmItems)
                return realmTimeGroup
            }
            let realmRecordGroup = RealmReminderRecordGroup()
            realmRecordGroup.date = record.date
            realmRecordGroup.timeGroups.append(objectsIn: realmTimeGroups)
            return realmRecordGroup
        }
        
        /*
        try! realm.write {
            realm.add(realmRecords, update: .modified)
        }
        */
    }
    
    // 根据日期范围从 Realm 中获取提醒通知
    func fetchRemindersFromCache(startDate: String, endDate: String) -> [RealmReminderRecordGroup]? {
        let reminders = realm.objects(RealmReminderRecordGroup.self)
            .filter("date >= %@ AND date <= %@", startDate, endDate)
        return reminders.isEmpty ? nil : Array(reminders)
    }
    
    // 清除所有提醒通知
    func clearReminders() {
        /*
        try! realm.write {
            realm.delete(realm.objects(RealmReminderRecordGroup.self))
        }
        */
    }
    
    // 检查是否需要重新从 API 获取数据
    func shouldFetchFromAPI() -> Bool {
        guard let lastFetch = lastFetchTime else {
            return true
        }
        return Date().timeIntervalSince(lastFetch) > cacheDuration
    }
    
    // 获取提醒通知（使用缓存逻辑）
    func getReminders(startDate: String, endDate: String, completion: @escaping ([RealmReminderRecordGroup]?) -> Void) {
        if useCache && !shouldFetchFromAPI() {
            // 使用缓存数据
            completion(fetchRemindersFromCache(startDate: startDate, endDate: endDate))
        } else {
            // 从 API 获取数据
            /*
             fetchRemindersFromAPI(startDate: startDate, endDate: endDate) { [weak self] apiRecords in
             guard let self = self else { return }
             if let apiRecords = apiRecords {
             // 将 API 返回的数据保存到 Realm
             self.saveReminders(reminderRecords: apiRecords)
             // 返回保存到 Realm 的数据
             completion(self.fetchRemindersFromCache(startDate: startDate, endDate: endDate))
             } else {
             completion(nil)
             }
             }
             */
        }
    }
    
    // 新方法：询问是否应该使用缓存数据
    func shouldUseCache() -> Bool {
        return useCache && !shouldFetchFromAPI()
    }
}
*/
