//
//  CommonSettings.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import UIKit
import Foundation

let NoSelection = -1
let APPDELEGATE = (UIApplication.shared.delegate as! AppDelegate)
let Google_Place_Api_Key = ""
let debounceValue = Int(0.5)
let PROGRESS_INDICATOR_VIEW_TAG:Int = 10
let PopUp_Frame = CGRect(x: 0, y:  0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
let device_LanguageCode = Locale.current.languageCode
let viewTopBarHeightForIphoneXOrAbove = CGFloat(84.0)
let topBarHeight = CGFloat(64.0)
let maxRequiredWidth = CGFloat(550.0)
let ezClaimIP = "http://59.120.6.62"

/*
 ●「預約確認」 RESERVATION_ACCEPT
 ●「等待領藥」 RESERVATION_PREPARED
 ●「領藥完成」 RESERVATION_RECEIVED
 ●「領藥取消」 RESERVATION_CANCEL
 
 「可約診」通知
 FOLLOW_UP_OUTPATIENT_APPOINTMENT_REQUESTABLE
 「預約領藥」通知
 NEXT_RESERVATION_REQUESTABLE
 「處方箋到期」通知
 PRESCRIPTION_ENDED
 
 "tenantId": "cehr-04129719-buc4g",
 "medicalType": "1",
 "diagnosisNo": "1",
 "prescriptionNo": "AC001"
 
  *現場-領藥完成*
  ON_SITE_RECEIVED("領藥提醒", "您於 OO藥局 的領藥已經完成", ""),
  *現場-領藥取消*
  ON_SITE_CANCELED("領藥請求已取消", "請重新預約或前往現場領藥", "")
  TAKE_MEDICATION_ALERT("用藥提醒", "請記得服用指定藥物喔", "");
 */
enum PushNotificationRedirection: String {
    case RESERVATION_ACCEPT  /* step 2 */
    case RESERVATION_PREPARED  /* step 3 */
    case RESERVATION_RECEIVED  /* step 4 */
    case RESERVATION_CANCEL  /* QRCode */
    // case MedicationReminder_6  /* N/A */
    case FOLLOW_UP_OUTPATIENT_APPOINTMENT_REQUESTABLE
    case NEXT_RESERVATION_REQUESTABLE
    case PRESCRIPTION_ENDED
    case ON_SITE_RECEIVED
    case ON_SITE_CANCELED
    case TAKE_MEDICATION_ALERT
}

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

func getScreenSize()->CGSize {
    return UIScreen.main.bounds.size
}

func defaultThemeColor()->UIColor {
    return UIColor.blue.withAlphaComponent(0.3)
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct CommonSettings {
    
#if STAGE
    static var channel: PHI_SDK_Channel = .stage
#elseif SOFTLAUNCH
    static var channel: PHI_SDK_Channel = .softlaunch
#elseif PRODUCTION
    static var channel: PHI_SDK_Channel = .production
#else
    static var channel: PHI_SDK_Channel = .dev
#endif
    
    static var serverDomain: String {
        switch channel {
        case .dev, .stage:
            // For Demo FirstView
            return "https://randomuser.me/api"
        case .softlaunch, .production:
            // For Demo SecondView
            return "https://dog-api.kinduff.com/api"
        @unknown default:
            print("unknown default")
            return ""
        }
    }
    
    static var downloadCenter: String {
        switch channel {
        case .dev, .stage:
            return "https://prelaunch.fun88asia.com/th/download/home.htm"
        case .softlaunch, .production:
            return "https://www.fun88-I78.com/th/download/home.htm"
        @unknown default:
            print("unknown default")
            return ""
        }
    }
    
    static var piwikKey: String {
        switch channel {
        case .dev, .stage:
            return "b9428397-fd04-49d1-90bc-87c749e74535"
        case  .softlaunch, .production:
            return "f1c30a68-baf3-4ace-a8d1-5d051aab7def"
        @unknown default:
            print("unknown default")
            return ""
        }
    }
    
    static var piwikDispatchInterval: TimeInterval {
#if PRODUCTION
        return 900000
#else
        return 0
#endif
    }
    
    static var googleMapApiKey: String {
        switch channel {
        case .dev, .stage:
            return "AIzaSyBAFFgsG9OhnBIsTw1RcDDxpmVvqyd6nLQ"
            //return "AIzaSyCdwRzGcZWAaQiJGN41FwS41UThbq3rPyE"
        case  .softlaunch, .production:
            return "AIzaSyBAFFgsG9OhnBIsTw1RcDDxpmVvqyd6nLQ"
            //return "AIzaSyCdwRzGcZWAaQiJGN41FwS41UThbq3rPyE"
        @unknown default:
            print("unknown default")
            return ""
        }
    }
    
    static var httpRequestHeaderClient: String {
        switch channel {
        case .dev, .stage:
            return "phi-app"
        case  .softlaunch, .production:
            return "phi-app"
        @unknown default:
            print("unknown default")
            return ""
        }
    }
    
    static var KeycloakCode: String {
        switch channel {
        case .dev, .stage:
            //return "t5wgqKccu362XHr0I6Ob7oRY6D6JxyJ1"
            return "glkdHvUEn0kNKtUKmWDHSPenMkM6zZ7O"
        case  .softlaunch, .production:
            return "glkdHvUEn0kNKtUKmWDHSPenMkM6zZ7O"
        @unknown default:
            print("unknown default")
            return "glkdHvUEn0kNKtUKmWDHSPenMkM6zZ7O"
        }
    }
    
    static var TenantId: String {
        switch channel {
        case .dev, .stage:
            return "PHI"
        case  .softlaunch, .production:
            return "PHI"
        @unknown default:
            print("unknown default")
            return "PHI"
        }
    }
    
    static var ProgressHUDText: String {
        switch channel {
        case .dev, .stage:
            return "請稍候..."
        case  .softlaunch, .production:
            return "請稍候..."
        @unknown default:
            print("unknown default")
            return "請稍候..."
        }
    }
}

extension Notification.Name {
    static let refreshTokenSuccess = Notification.Name("RefreshTokenSuccess")
    
    static let switchToFinishJourneyThenReload = Notification.Name("SwitchToFinishJourneyThenReload")
    static let switchToProgressJourneyThenReload = Notification.Name("SwitchToProgressJourneyThenReload")
    
    static let pushToQRcodePage = Notification.Name("PushToQRcodePage")
    static let pushToLocationPage = Notification.Name("PushToLocationPage")
    static let pushToResultPage = Notification.Name("pushToResultPage")
    static let pushToAppointStepPage = Notification.Name("pushToAppointStepPage")
    
    static let AppointVC_Reload = Notification.Name("AppointStep1VC_Reload")
    static let InProgressMedVC_Reload = Notification.Name("InProgressMedJourneyVC_Reload")
    static let MedLocationVC_Reload = Notification.Name("MedLocationVC_Reload")
    static let FinishMedVC_Reload = Notification.Name("FinishMedJourneyVC_Reload")
    static let MedResultVC_Reload = Notification.Name("MedResultVC_Reload")
    static let MedQRCodeVC_Reload = Notification.Name("MedQRCodeVC_Reload")
    
    static let pushToMedicationManagementPage = Notification.Name("PushToMedicationManagementPage")
    
    static let appLogout = Notification.Name("AppLogout")
}
