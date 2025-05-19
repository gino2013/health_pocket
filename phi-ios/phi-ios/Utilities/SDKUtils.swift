//
//  SDKUtils.swift
//  SDK
//
//  Created by Kenneth on 2023/9/28.
//

import Foundation
import UIKit

public struct SDKUtils {

    /// 取得或設置應用程式中最頂層的 `UIViewController`。
    /// - `get`: 從當前活動的 `UIWindowScene` 中取得最頂層的 `UIViewController`。
    /// - `set`: 將最頂層的 `UIViewController` 設置為新值。
    public static var mostTopViewController: UIViewController? {
        get {
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            
            return keyWindow?.rootViewController
        }
        set {
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            
            keyWindow?.rootViewController = newValue
        }
    }
}

extension SDKUtils {

    /// 取得當前顯示的 `UIViewController`。
    /// - Parameter topViewcontroller: 當前最頂層的 `UIViewController`，預設為 `mostTopViewController`。
    /// - Returns: 當前顯示的 `UIViewController`，若無則返回 `nil`。
    public static func visibleViewController(_ topViewcontroller: UIViewController? = mostTopViewController) -> UIViewController? {
        if let navController = topViewcontroller as? UINavigationController {
            return visibleViewController(navController.visibleViewController)
        }
        
        if let tabBarController = topViewcontroller as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return visibleViewController(selectedViewController)
        }
        
        if let presentedViewController = topViewcontroller?.presentedViewController {
            return visibleViewController(presentedViewController)
        }
        
        return topViewcontroller
    }
    
    /// 延遲執行指定的閉包操作。
    /// - Parameters:
    ///   - delay: 延遲時間，以秒為單位。
    ///   - closure: 要延遲執行的閉包操作。
    public static func delay(_ delay: Double, closure: @escaping () -> Void) {
        let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }
    
    /// 設置崩潰日誌記錄功能。
    /// 當發生未捕獲的異常時，將異常信息寫入到 `crash.log` 文件中並保存到應用程式的 `Documents` 目錄。
    public static func setupCrashLogging() {
        NSSetUncaughtExceptionHandler { exception in
            let exceptionInfo = """
            Exception Name: \(exception.name.rawValue)
            Reason: \(exception.reason ?? "")
            Stack Trace: \(exception.callStackSymbols.joined(separator: "\n"))
            """

            // 將崩潰資訊寫入 `crash.log` 文件並存儲到 `Documents` 目錄中
            if let logFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/crash.log") {
                try? exceptionInfo.write(toFile: logFilePath, atomically: true, encoding: .utf8)
            }
        }
    }
    
    /// 獲取崩潰日誌的文件路徑。
    /// - Returns: `crash.log` 文件的路徑。
    public static func getCrashLogPath() -> String {
        let str = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let urlPath = str.appending("/crash.log")
        return urlPath
    }
}
