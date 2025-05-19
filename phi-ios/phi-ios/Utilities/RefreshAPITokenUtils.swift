//
//  RefreshAPITokenUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/3.
//

import Foundation
import KeychainSwift

class RefreshAPITokenUtils {
    static let shared = RefreshAPITokenUtils()
    private init() {}
    
    func refreshApiToken(requestCompleted: @escaping (Bool) -> Void) {
        let requestInfo: RefreshTokenModel = RefreshTokenModel(refreshToken: SharingManager.sharedInstance.refreshToken)
        
        SDKManager.sdk.requestRefreshToken(requestInfo) {
            (responseModel: PhiResponseModel<RefreshTokenRspModel>) in
            
            if responseModel.success {
                guard let refreshTokenRspModel = responseModel.data else {
                    return
                }
                
                UserDefaults.standard.setDurationInSecond(value: refreshTokenRspModel.durationInSecond)
                SharingManager.sharedInstance.refreshToken = refreshTokenRspModel.refreshToken
                
                // for send API
                let keychain = KeychainSwift()
                keychain.set(refreshTokenRspModel.idToken, forKey: "idToken")
                
                requestCompleted(true)
            } else {
                // ???
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                requestCompleted(false)
            }
        }
    }
}
