//
//  SharingManager.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/18.
//

import Foundation

enum AuthorizationMode: Int {
    case changeAuthorization
    case addAuthorization
    case firstAuthorization
}

enum SetReminderMode: Int {
    case auto
    case manual
    case edit
    // case fromMedicineResult
}

class SharingManager {
    static var sharedInstance = SharingManager()
    init() {}
    
    var fcmToken: String = ""
    
    // "國泰醫院", "臺大醫院", "健康醫院", "平安醫院"
    var authDoneHospitals: [String] = []
    var medicalHistorys: [String] = []
    var refreshToken: String = ""
    var effectiveMedicalAuth: Bool = false
    
    // 授權
    var currentAuthPartnerId: Int = 0
    var currentAuthType: AuthorizationMode = .addAuthorization
    var currDeptNames: [String] = []
    var currDeptCodes: [String] = []
    
    // 處方箋 Note: 0702_2024 和推播參數整合
    // var currentMedicalRecordModel: MedicalRecordRspModel?
    
    // Message Center
    var isRcvNewMessage: Bool = false
    var unreadMessageCount: Int = 0
    var msgCenterPushToMedicationManagementPage: Bool = false
    
    /* 推播可能需要跳轉的畫面 */
    // 醫療歷程
    var isInProgressMedJourneyVController: Bool = false
    var isFinishMedJourneyVController: Bool = false
    // 預約
    var isAppointStep1ViewController: Bool = false
    // 現場
    var isMedicineQRViewController: Bool = false
    // 地圖
    var isMedLocationViewController: Bool = false
    // 結果
    var isMedResultViewController: Bool = false
    
    /* 推播跳轉到指定畫面後之API參數 */
    var isPushNotificationMode: Bool = false
    var apns_tenantId: String = ""
    var apns_medicalType: String = ""
    var apns_diagnosisNo: String = ""
    var apns_prescriptionNo: String = ""
    var apns_receiveRecordId: String = ""
    var apns_RESERVATION_or_ONSITE_CANCEL: Bool = false
    
    /* Local Notification 參數 */
    var isLocalNotificationMode: Bool = false
    var localNotif_reminderDate: String = ""
    var localNotif_reminderTime: String = ""
    var localNotif_reminderSettingId: String = ""
    var localNotif_reminderTimeSettingId: String = ""
    
    // Reminder
    var currAutoImportPrescriptionInfos: [PrescriptionInfo] = []
    var reminderPushToMedicationManagementPage: Bool = false
    
    // Manual
    var currentSetReminderMode: SetReminderMode = .auto
    var currManualPrescriptionInfos: [PrescriptionInfo] = []
}
