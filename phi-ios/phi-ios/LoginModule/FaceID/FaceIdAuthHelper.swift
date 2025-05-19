//
//  FaceIdAuthHelper.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/27.
//

import Foundation
import LocalAuthentication

class FaceIdAuthHelper: ObservableObject {
    static let shared = FaceIdAuthHelper()
    
    @Published var biometricType: LABiometryType = .none
    
    init() {
        // 初始化生物識別能力檢查
        refreshBiometricType()
    }
    
    // 刷新設備的生物識別能力
    private func refreshBiometricType() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            biometricType = context.biometryType
        } else {
            biometricType = .none
        }
    }
    
    /// 檢查生物識別是否可用
    func askBiometricAvailability(completion: @escaping (Error?) -> Void) {
        let context = LAContext()
        var failureReason: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &failureReason) {
            biometricType = context.biometryType
            completion(nil)
        } else {
            biometricType = .none
            completion(failureReason)
        }
    }
    
    /// 執行身份驗證
    func authenticate(completion: @escaping (Result<Bool, LAError>) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        context.localizedFallbackTitle = "輸入密碼" // 設置“輸入密碼”按鈕
        
        // let reason = "需要您的 Face ID 或 Touch ID 進行身份驗證"
        let reason = "輸入您的密碼"
        
        // 使用更廣泛的策略，允許回退到密碼
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            completion(.failure(LAError(.biometryNotAvailable)))
            return
        }
        
        // 執行驗證
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            if success {
                completion(.success(true))
            } else if let error = error as? LAError {
                self.handleAuthError(error: error, completion: completion)
            } else {
                completion(.failure(LAError(.authenticationFailed)))
            }
        }
    }

    /// 處理身份驗證錯誤
    private func handleAuthError(error: LAError, completion: @escaping (Result<Bool, LAError>) -> Void) {
        switch error.code {
        case .authenticationFailed:
            // 驗證失敗
            completion(.failure(error))
        case .userCancel:
            // 使用者取消
            completion(.failure(error))
        case .userFallback:
            // 使用者選擇輸入密碼
            completion(.failure(error))
        case .systemCancel:
            // 系統取消
            completion(.failure(error))
        case .passcodeNotSet:
            // 設備未設定密碼
            completion(.failure(error))
        case .biometryNotAvailable:
            // 生物識別不可用
            completion(.failure(error))
        case .biometryLockout:
            // 生物識別被鎖定
            completion(.failure(error))
        case .biometryNotEnrolled:
            // 生物識別未註冊
            completion(.failure(error))
        case .appCancel:
            // 應用程式取消
            completion(.failure(error))
        case .invalidContext:
            // Context 已經無效
            completion(.failure(error))
        case .notInteractive:
            // 需要用戶交互，但未允許
            completion(.failure(error))
        default:
            // 其他未知錯誤
            completion(.failure(error))
        }
    }
}
