//
//  AppDelegate.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import UIKit
import CoreData
import UserNotifications

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging

import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    // for checkmarx
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        // 禁用第三方鍵盤
        return extensionPointIdentifier != UIApplication.ExtensionPointIdentifier.keyboard
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDgh4ax2MHAN9XoufwpV_Q1Un8bNt6vnxc")
        //GMSPlacesClient.provideAPIKey("AIzaSyDgh4ax2MHAN9XoufwpV_Q1Un8bNt6vnxc")
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // [START register_for_notifications]
        // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // 处理收到的远程通知
        // 这里你可以自定义通知处理逻辑
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // iOS 10以前使用，應該不會用到這個function
        print("Warning! < iOS 10 ?")
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // print("APNs token retrieved: \(deviceToken)")
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(token)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    // iOS 13之後，不會被調用
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // 檢查是否是您的 URL Scheme
        guard url.scheme == "phi-ios" else { return false }
        
        // 確認 host 和 path，並解析參數
        if url.host == "HualienTzuChi" {
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let paramValue = queryItems?.first(where: { $0.name == "param" })?.value
            
            print("Received param: \(paramValue ?? "No value")")
            // 根據需要處理 paramValue
        }
        
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "phi_ios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        print("userNotificationCenter willPresent!")
        // [START_EXCLUDE]
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        
        //print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.list, .banner, .sound]]
    }
    
    // Custom method to handle notifications
    private func handleNotification(notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        
        // [START_EXCLUDE]
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        
        print("userNotificationCenter didReceive!")
        print(userInfo)
        
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            // 背景收到遠端推播 並點擊推播
#if targetEnvironment(simulator)
            if let aps = userInfo["aps"] as? [String: Any] {
                SharingManager.sharedInstance.isPushNotificationMode = true
                
                if let tenantId = aps["tenantId"] {
                    SharingManager.sharedInstance.apns_tenantId = tenantId as! String
                }
                if let medicalType = aps["medicalType"] {
                    SharingManager.sharedInstance.apns_medicalType = medicalType as! String
                }
                if let diagnosisNo = aps["diagnosisNo"] {
                    SharingManager.sharedInstance.apns_diagnosisNo = diagnosisNo as! String
                }
                if let prescriptionNo = aps["prescriptionNo"] {
                    SharingManager.sharedInstance.apns_prescriptionNo = prescriptionNo as! String
                }
                if let receiveRecordId = aps["receiveRecordId"] {
                    SharingManager.sharedInstance.apns_receiveRecordId = receiveRecordId as! String
                }
                
                if let remoteNotiyKeyWord = aps["pushNotificationType"] as? String,
                   let keyWord = PushNotificationRedirection(rawValue: remoteNotiyKeyWord) {
                    pushNotificationRedirection(keyWord: keyWord)
                }
            }
#else
            SharingManager.sharedInstance.isPushNotificationMode = true
            
            if let tenantId = userInfo["tenantId"] {
                SharingManager.sharedInstance.apns_tenantId = tenantId as! String
            }
            if let medicalType = userInfo["medicalType"] {
                SharingManager.sharedInstance.apns_medicalType = medicalType as! String
            }
            if let diagnosisNo = userInfo["diagnosisNo"] {
                SharingManager.sharedInstance.apns_diagnosisNo = diagnosisNo as! String
            }
            if let prescriptionNo = userInfo["prescriptionNo"]{
                SharingManager.sharedInstance.apns_prescriptionNo = prescriptionNo as! String
            }
            if let receiveRecordId = userInfo["receiveRecordId"] {
                SharingManager.sharedInstance.apns_receiveRecordId = receiveRecordId as! String
            }
            
            if let remoteNotiyKeyWord = userInfo["pushNotificationType"] as? String,
               let keyWord = PushNotificationRedirection(rawValue: remoteNotiyKeyWord) {
                pushNotificationRedirection(keyWord: keyWord)
            }
            
#endif
            
        } else {
            // 背景收到本地推播 並點擊推播
            // Note: need write info. to server
            
            SharingManager.sharedInstance.isLocalNotificationMode = true
            
            if let reminderDate = userInfo["reminderDate"] {
                SharingManager.sharedInstance.localNotif_reminderDate = reminderDate as! String
            }
            if let reminderTime = userInfo["reminderTime"] {
                SharingManager.sharedInstance.localNotif_reminderTime = reminderTime as! String
            }
            if let reminderSettingId = userInfo["reminderSettingId"] {
                SharingManager.sharedInstance.localNotif_reminderSettingId = reminderSettingId as! String
            }
            if let reminderTimeSettingId = userInfo["reminderTimeSettingId"] {
                SharingManager.sharedInstance.localNotif_reminderTimeSettingId = reminderTimeSettingId as! String
            }
            
            //if let aps = userInfo["aps"] as? [String: Any] {
                if let localNotiyKeyWord = userInfo["pushNotificationType"] as? String,
                   let keyWord = PushNotificationRedirection(rawValue: localNotiyKeyWord) {
                    pushNotificationRedirection(keyWord: keyWord)
                }
            //}
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        handleNotification(notification: response.notification)
    }
    
    func popToRootThenSwitchToFirstTab() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let tabBarController = window.rootViewController as? UITabBarController else {
            return
        }
        
        // Get the current navigation controller of the third tab
        if let navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController {
            // Pop to root view controller
            navigationController.popToRootViewController(animated: false)
        }
        
        if tabBarController.selectedIndex == 0 {
            if let firstNavController = tabBarController.viewControllers?[0] as? UINavigationController,
               let firstViewController = firstNavController.viewControllers.first as? MedicalJourneyVController {
                firstViewController.reloadInProgressMedJourneyData()
            }
        } else {
            // Switch to the first tab
            tabBarController.selectedIndex = 0
        }
    }
    
    func navigateToMedicationAlertViewController() {
        // 假設 ViewController 已經載入完畢，直接跳轉到指定的頁面
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        rootVC?.selectedIndex = 1
        
        
    }
    
    func pushNotificationRedirection(keyWord: PushNotificationRedirection) {
        switch keyWord {
        case .RESERVATION_ACCEPT, .RESERVATION_PREPARED:
            print("Handle \(keyWord.rawValue)!")
            if !SharingManager.sharedInstance.isAppointStep1ViewController {
                NotificationCenter.default.post(
                    name: .switchToProgressJourneyThenReload,
                    object: self,
                    userInfo: nil)
                NotificationCenter.default.post(
                    name: .pushToAppointStepPage,
                    object: self,
                    userInfo: nil)
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .AppointVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
            
        case .RESERVATION_RECEIVED, .ON_SITE_RECEIVED:
            print("Handle \(keyWord.rawValue)!")
            // backToRoot
            if !SharingManager.sharedInstance.isMedResultViewController {
                NotificationCenter.default.post(
                    name: .switchToProgressJourneyThenReload,
                    object: self,
                    userInfo: nil)
                NotificationCenter.default.post(
                    name: .pushToResultPage,
                    object: self,
                    userInfo: nil)
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .MedResultVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
            
        case .RESERVATION_CANCEL, .ON_SITE_CANCELED:
            print("Handle \(keyWord.rawValue)!")
            
            SharingManager.sharedInstance.apns_RESERVATION_or_ONSITE_CANCEL = true
            
            if !SharingManager.sharedInstance.isMedicineQRViewController {
                NotificationCenter.default.post(
                    name: .switchToProgressJourneyThenReload,
                    object: self,
                    userInfo: nil)
                NotificationCenter.default.post(
                    name: .pushToQRcodePage,
                    object: self,
                    userInfo: nil)
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .MedQRCodeVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
            
        case .TAKE_MEDICATION_ALERT:
            print("Handle TAKE_MEDICATION_ALERT")
            SharingManager.sharedInstance.msgCenterPushToMedicationManagementPage = true
            navigateToMedicationAlertViewController()
            
        case .FOLLOW_UP_OUTPATIENT_APPOINTMENT_REQUESTABLE:
            print("Handle InProgressMedJourney_7")
            if !SharingManager.sharedInstance.isInProgressMedJourneyVController {
                NotificationCenter.default.post(
                    name: .switchToProgressJourneyThenReload,
                    object: self,
                    userInfo: nil)
                
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .InProgressMedVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
            
        case .NEXT_RESERVATION_REQUESTABLE:
            print("Handle MedLocation_8")
            if !SharingManager.sharedInstance.isMedLocationViewController {
                NotificationCenter.default.post(
                    name: .switchToProgressJourneyThenReload,
                    object: self,
                    userInfo: nil)
                NotificationCenter.default.post(
                    name: .pushToLocationPage,
                    object: self,
                    userInfo: nil)
                
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .MedLocationVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
            
        case .PRESCRIPTION_ENDED:
            print("Handle FinishMedJourney_9")
            if !SharingManager.sharedInstance.isFinishMedJourneyVController {
                NotificationCenter.default.post(
                    name: .switchToFinishJourneyThenReload,
                    object: self,
                    userInfo: nil)
                
                popToRootThenSwitchToFirstTab()
            } else {
                NotificationCenter.default.post(
                    name: .FinishMedVC_Reload,
                    object: self,
                    userInfo: nil)
                SharingManager.sharedInstance.isPushNotificationMode = false
            }
        }
        
    }
}

// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        if let fcmToken = fcmToken {
            SharingManager.sharedInstance.fcmToken = fcmToken
        }
        
        /*
         let dataDict: [String: String] = ["token": fcmToken ?? ""]
         NotificationCenter.default.post(
         name: Notification.Name("FCMToken"),
         object: nil,
         userInfo: dataDict
         )
         */
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
}
