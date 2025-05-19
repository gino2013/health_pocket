//
//  LocalNotificationUtils.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/30.
//

import UserNotifications
import Foundation

/*
let syncReminderNotifModel = SyncReminderNotifRspModel(json: json)
if let models = syncReminderNotifModel.dataArray {
    LocalNotificationUtils.removeAllLocalNotifications()
    LocalNotificationUtils.scheduleLocalNotifications(from: models)
}
*/

class LocalNotificationUtils {
    static func syncAndGetReminderNotifications(completion: @escaping () -> Void) {
        SDKManager.sdk.syncAndGetReminderNotifications() {
            (responseModel: PhiResponseModel<SyncReminderNotifRspModel>) in
            
            if responseModel.success {
                guard let reminderNotifRspInfo = responseModel.data,
                      let notifInfos = reminderNotifRspInfo.dataArray else {
                    completion()
                    return
                }
                
                print("notifInfos.count=\(notifInfos.count)!")
                
                LocalNotificationUtils.removeAllLocalNotifications()
                LocalNotificationUtils.scheduleLocalNotifications(from: notifInfos)
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
            
            completion()
        }
    }
    
    static func removeAllLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    static func scheduleLocalNotifications(from models: [ReminderNotificationModel]) {
        let center = UNUserNotificationCenter.current()
        
        for (index, model) in models.prefix(64).enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "提醒"
            content.body = model.content
            content.sound = UNNotificationSound.default
            // 將推播類型添加到 userInfo 中
            content.userInfo = ["pushNotificationType": model.pushNotificationType,
                                "reminderDate": model.parameters.reminderDate,
                                "reminderTime": model.parameters.reminderTime,
                                "reminderSettingId": "\(model.parameters.reminderSettingId)",
                                "reminderTimeSettingId": "\(model.parameters.reminderTimeSettingId)"]
            
            // 將 remindDateTime 轉換成 Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            guard let date = dateFormatter.date(from: model.remindDateTime) else {
                print("Invalid date format for \(model.remindDateTime)")
                continue
            }
            
            // 設置通知觸發器
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
            
            // 設置通知請求
            let request = UNNotificationRequest(identifier: "localNotification\(index)", content: content, trigger: trigger)
            
            // 添加通知請求到通知中心
            center.add(request) { error in
                if let error = error {
                    print("Failed to add notification request: \(error)")
                }
            }
        }
    }
    
    // 測試
    static func scheduleTestNotification(model: ReminderNotificationModel) {
        removeAllLocalNotifications()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "測試提醒"
        content.body = model.content
        content.sound = UNNotificationSound.default
        
        // 將推播類型添加到 userInfo 中
        content.userInfo = ["pushNotificationType": model.pushNotificationType,
                            "reminderDate": model.parameters.reminderDate,
                            "reminderTime": model.parameters.reminderTime,
                            "reminderSettingId": model.parameters.reminderSettingId,
                            "reminderTimeSettingId": model.parameters.reminderTimeSettingId]
        
        // 设置3分钟后的通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1 * 60, repeats: false)
        
        // 设置通知请求
        let request = UNNotificationRequest(identifier: "testLocalNotification", content: content, trigger: trigger)
        
        // 添加通知请求到通知中心
        center.add(request) { error in
            if let error = error {
                print("Failed to add test notification request: \(error)")
            } else {
                print("Test notification scheduled for 3 minutes later.")
            }
        }
    }
}
