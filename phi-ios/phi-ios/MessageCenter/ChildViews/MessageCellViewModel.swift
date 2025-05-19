//
//  MessageCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/25.
//

import Foundation

// Change to follow server
enum SystemNotificationType {
    // 預約領藥提醒 已可以領藥
    case AppointmentReminderReadyReceiveMedicine
    
    // 用藥提醒
    case MedicationReminder
    
    // 慢性處方箋約診提醒
    case ChronicPrescriptionAppointmentReminder
    
    // 預約領藥請求已取消
    case AppointmentCancelled
    
    // 預約領藥提醒 可預約領藥
    case AppointmentReminderCanReceiveMedicine
    
    // 處方箋到期提醒
    case PrescriptionExpirationReminder
}

class MessageCellViewModel {
    let pushNotificationId: Int
    let mainTitle: String
    let subTitle: String
    let subMessage: String
    let dateTime: String
    var haveRead: Bool
    let cellType: MessageCellType
    let sysNotificationType: PushNotificationRedirection
    
    init(pushNotificationId: Int, mainTitle: String, subTitle: String, subMessage: String, dateTime: String, haveRead: Bool, cellType: MessageCellType, sysNotificationType: PushNotificationRedirection) {
        self.pushNotificationId = pushNotificationId
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.subMessage = subMessage
        self.dateTime = dateTime
        self.haveRead = haveRead
        self.cellType = cellType
        self.sysNotificationType = sysNotificationType
    }
}

func systemMessageSampleData() -> [MessageCellViewModel] {
    var a = [MessageCellViewModel]()
    a.append(MessageCellViewModel(pushNotificationId: 0, mainTitle: "領藥提醒", subTitle: "參天藥局 已接受你的預約領藥申請", subMessage: "", dateTime: "15:41", haveRead: false, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_ACCEPT))
    a.append(MessageCellViewModel(pushNotificationId: 1, mainTitle: "領藥提醒", subTitle: "已經可以領藥囉！請前往預約藥局", subMessage: "", dateTime: "15:41", haveRead: false, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_PREPARED))
    a.append(MessageCellViewModel(pushNotificationId: 2, mainTitle: "領藥提醒", subTitle: "您於 參天藥局 的領藥已經完成", subMessage: "", dateTime: "15:41", haveRead: false, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_RECEIVED))
    a.append(MessageCellViewModel(pushNotificationId: 3, mainTitle: "用藥提醒", subTitle: "請記得服用指定藥物喔", subMessage: "飯前1錠止痛膜衣錠、飯前1錠胰島素", dateTime: "15:41", haveRead: false, cellType: .containSubMessageType, sysNotificationType: .TAKE_MEDICATION_ALERT))
    
    a.append(MessageCellViewModel(pushNotificationId: 4, mainTitle: "用藥提醒用藥提醒用藥提醒用藥提醒用藥提醒用藥提醒", subTitle: "請記得服用指定藥物喔請記得服用指定藥物喔請記得服用指定藥物喔", subMessage: "飯前1錠止痛膜衣錠、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素、飯前1錠胰島素", dateTime: "15:41", haveRead: false, cellType: .containSubMessageType, sysNotificationType: .TAKE_MEDICATION_ALERT))
    
    a.append(MessageCellViewModel(pushNotificationId: 5, mainTitle: "預約領藥請求已取消", subTitle: "請重新預約或前往現場領藥", subMessage: "", dateTime: "2023/12/10", haveRead: true, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_CANCEL))
    a.append(MessageCellViewModel(pushNotificationId: 6, mainTitle: "慢性處方箋約診提醒", subTitle: "處方箋已使用完畢，可以預約下次門診", subMessage: "請向醫療機構聯繫看診，領取新處方箋", dateTime: "2023/12/10", haveRead: true, cellType: .containSubMessageType, sysNotificationType: .ON_SITE_CANCELED))
    a.append(MessageCellViewModel(pushNotificationId: 7, mainTitle: "預約領藥提醒", subTitle: "已經可以預約下次領藥囉！請前往預約", subMessage: "", dateTime: "2023/12/10", haveRead: true, cellType: .noSubMessageType, sysNotificationType: .NEXT_RESERVATION_REQUESTABLE))
    a.append(MessageCellViewModel(pushNotificationId: 8, mainTitle: "處方箋到期提醒", subTitle: "您的處方箋已經到期", subMessage: "請向醫療機構聯繫看診，領取新處方箋", dateTime: "2023/12/10", haveRead: true, cellType: .containSubMessageType, sysNotificationType: .PRESCRIPTION_ENDED))
    a.append(MessageCellViewModel(pushNotificationId: 9, mainTitle: "預約領藥請求已取消", subTitle: "請重新預約或前往現場領藥", subMessage: "", dateTime: "2023/12/10", haveRead: true, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_CANCEL))
    a.append(MessageCellViewModel(pushNotificationId: 10, mainTitle: "慢性處方箋約診提醒", subTitle: "處方箋已使用完畢，可以預約下次門診", subMessage: "請向醫療機構聯繫看診，領取新處方箋", dateTime: "2023/12/10", haveRead: true, cellType: .containSubMessageType, sysNotificationType: .FOLLOW_UP_OUTPATIENT_APPOINTMENT_REQUESTABLE))
    a.append(MessageCellViewModel(pushNotificationId: 11, mainTitle: "預約領藥提醒", subTitle: "已經可以預約下次領藥囉！請前往預約", subMessage: "", dateTime: "2023/12/10", haveRead: true, cellType: .noSubMessageType, sysNotificationType: .NEXT_RESERVATION_REQUESTABLE))
    a.append(MessageCellViewModel(pushNotificationId: 12, mainTitle: "處方箋到期提醒", subTitle: "您的處方箋已經到期", subMessage: "請向醫療機構聯繫看診，領取新處方箋", dateTime: "2023/12/10", haveRead: true, cellType: .containSubMessageType, sysNotificationType: .PRESCRIPTION_ENDED))
    
    return a
}

func personalMessageSampleData() -> [MessageCellViewModel] {
    var a = [MessageCellViewModel]()
    a.append(MessageCellViewModel(pushNotificationId: 0, mainTitle: "領藥提醒", subTitle: "參天藥局 已接受你的預約領藥申請", subMessage: "", dateTime: "15:41", haveRead: false, cellType: .noSubMessageType, sysNotificationType: .RESERVATION_ACCEPT))
    return a
}
