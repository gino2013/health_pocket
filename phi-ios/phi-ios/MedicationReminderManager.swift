//
//  MedicationReminderManager.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/16.
//

import Foundation

enum FrequencyType {
    case daily
    case weekly(days: [String])
    case interval(days: Int)
    
    // "frequencyType": "DAILY",
    // 頻率類型: DAILY-每日 WEEKLY-每週 DAY_PERIOD-每次間隔幾日
    var apiParameter: String {
        switch self {
        case .daily:
            return "DAILY"
        case .weekly:
            return "WEEKLY"
        case .interval:
            return "DAY_PERIOD"
        }
    }
    
    var intervalDays: Int? {
        if case .interval(let days) = self {
            return days
        }
        return nil
    }
    
    var weeklyDays: [String]? {
        if case .weekly(let days) = self {
            return days
        }
        return nil
    }
}

// 用藥提醒類別
class MedicationReminder {
    var reminderId: String
    var medicationNames: [String]
    var medicationIds: [Int]
    var frequencyType: FrequencyType
    var times: [String]
    var period: String
    var startDate: String
    var endDate: String
    var medicineInfos: [MedicineInfo]
    
    init(reminderId: String, medicationNames: [String], medicationIds: [Int], frequencyType: FrequencyType, times: [String], period: String, startDate: String, endDate: String, medicineInfos: [MedicineInfo]) {
        self.reminderId = reminderId
        self.medicationNames = medicationNames
        self.medicationIds = medicationIds
        self.frequencyType = frequencyType
        self.times = times
        self.period = period
        self.startDate = startDate
        self.endDate = endDate
        self.medicineInfos = medicineInfos
    }
    
    func combinedMedicationNames() -> String {
        return medicationNames.joined(separator: "、")
    }
    
    // 組合用藥時間
    func combinedTimes() -> String {
        return times.joined(separator: "、")
    }
    
    // 取得用藥頻率
    func frequencyDescription() -> String {
        switch frequencyType {
        case .daily:
            return "每日"
        case .weekly(let days):
            let dayMapping = [
                "1": "週一",
                "2": "週二",
                "3": "週三",
                "4": "週四",
                "5": "週五",
                "6": "週六",
                "7": "週日"
            ]
            let mappedDays = days.compactMap { dayMapping[$0] }
            return "每週" + mappedDays.joined(separator: "/")
        case .interval(let days):
            return "每\(days)天"
        }
    }
    
    // 取得用藥期間
    func getPeriod() -> String {
        return period
    }
    
    // 動態增加藥品名稱
    func addMedicationName(_ name: String) {
        medicationNames.append(name)
    }
    
    // 動態刪除藥品名稱
    func removeMedicationName(_ name: String) {
        if let index = medicationNames.firstIndex(of: name) {
            medicationNames.remove(at: index)
        }
    }
    
    func update(medicationNames: [String], medicationIds: [Int], frequencyType: FrequencyType, times: [String], period: String) {
        self.medicationNames = medicationNames
        self.medicationIds = medicationIds
        self.frequencyType = frequencyType
        self.times = times
        self.period = period
    }
}

class MedicationReminderManager {
    static let shared = MedicationReminderManager()
    private var reminders: [MedicationReminder] = []
    private init() {}
    
    // 創建新的 MedicationReminder
    func createReminder(reminderId: String, medicationNames: [String], medicationIds: [Int], frequencyType: FrequencyType, times: [String], period: String, startDate: String, endDate: String, medicineInfo: [MedicineInfo]) -> MedicationReminder {
        let reminder = MedicationReminder(reminderId: reminderId, medicationNames: medicationNames, medicationIds: medicationIds, frequencyType: frequencyType, times: times, period: period, startDate: startDate, endDate: endDate, medicineInfos: medicineInfo)
        reminders.append(reminder)
        return reminder
    }
    
    // 删除提醒
    func deleteReminder(byID reminderId: String) {
        if let index = reminders.firstIndex(where: { $0.reminderId == reminderId }) {
            reminders.remove(at: index)
        }
    }
    
    // 刪除提醒並返回藥品IDs
    func deleteReminder(byID reminderId: String) -> [Int]? {
        if let index = reminders.firstIndex(where: { $0.reminderId == reminderId }) {
            let medicationIds = reminders[index].medicationIds
            reminders.remove(at: index)
            return medicationIds
        }
        return nil
    }
    
    // 刪除指定的 MedicationReminder
    func deleteReminder(reminder: MedicationReminder) {
        if let index = reminders.firstIndex(where: { $0 === reminder }) {
            reminders.remove(at: index)
        }
    }
    
    // 返回藥品IDs
    func getMedicationIds(byID reminderId: String) -> [Int]? {
        if let index = reminders.firstIndex(where: { $0.reminderId == reminderId }) {
            let medicationIds = reminders[index].medicationIds
            return medicationIds
        }
        return nil
    }
    
    // 取得所有提醒
    func getAllReminders() -> [MedicationReminder] {
        return reminders
    }
    
    func deleteAllReminders() {
        reminders.removeAll()
    }
    
    // 編輯提醒
    func editReminder(reminderId: String, medicationNames: [String], medicationIds: [Int], frequencyType: FrequencyType, times: [String], period: String) {
        if let reminder = reminders.first(where: { $0.reminderId == reminderId }) {
            reminder.update(medicationNames: medicationNames, medicationIds: medicationIds, frequencyType: frequencyType, times: times, period: period)
        }
    }
    
    // 修改指定提醒的 MedicineInfo 別名
    func modifyMedicineInfoAlias(reminderId: String, medicineAlias: [String]) {
        if let reminder = reminders.first(where: { $0.reminderId == reminderId }) {
            for (index, alias) in medicineAlias.enumerated() {
                if index < reminder.medicineInfos.count {
                    reminder.medicineInfos[index].medicineNameAlias = alias
                }
            }
        }
    }
    
    // 修改指定提醒的 MedicineInfo 四個變數
    func modifyMedicineInfo(reminderId: String, medicineInfoUpdates: [(dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String)]) {
        if let reminder = reminders.first(where: { $0.reminderId == reminderId }) {
            for (index, update) in medicineInfoUpdates.enumerated() {
                if index < reminder.medicineInfos.count {
                    let medicineInfo = reminder.medicineInfos[index]
                    medicineInfo.dose = update.dose
                    medicineInfo.doseUnits = update.doseUnits
                    medicineInfo.medicineName = update.medicineName
                    medicineInfo.medicineNameAlias = update.medicineNameAlias
                    medicineInfo.useTime = update.takingTime
                }
            }
        }
    }
    
    func createAPIRequestModel() -> [ReminderSetting] {
        var result: [ReminderSetting] = []
        
        for i in 0 ..< reminders.count {
            let item: MedicationReminder = reminders[i]
            
            for j in 0 ..< item.medicineInfos.count {
                let jItem: MedicineInfo = item.medicineInfos[j]
                var gIntervalDays: Int = 1
                var gWeeklyDays: [String] = ["1"]
                
                if let intervalDays = item.frequencyType.intervalDays {
                    // print("Interval days: \(intervalDays)") // Output: Interval days: 12
                    gIntervalDays = intervalDays
                }
                if let weeklyDays = item.frequencyType.weeklyDays {
                    // print("Weekly days: \(weeklyDays)") // Output: Weekly days: ["1", "2"]
                    gWeeklyDays = weeklyDays
                }
                
                let reminder1 = ReminderSetting(startDate: item.startDate, endDate: item.endDate, frequencyType: item.frequencyType.apiParameter, remindTimes: item.times, type: "MEDICINE", frequencyWeekdays: gWeeklyDays, frequencyDays: gIntervalDays, medicineInfo: jItem)
                result.append(reminder1)
            }
        }
        
        return result
    }
}
