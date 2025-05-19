//
//  PHI_SDKAPI+Keycloak.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/7.
//

import Foundation
import UIKit

extension PHI_SDKAPI {
    // 重新取得Token
    func requestRefreshToken(_ postModel: RefreshTokenModel, requestCompleted: @escaping (PhiResponseModel<RefreshTokenRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.refresh-token", domain: serverUrl)
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let requestRefreshTokenPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  requestRefreshTokenPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 登入 PHI Server */
    func requestLogin(_ postModel: LoginModel, requestCompleted: @escaping (PhiResponseModel<LoginRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.login", domain: serverUrl)
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let loginPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  loginPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    // 註冊相關
    func getRsaPublicKey(requestCompleted: @escaping (PhiResponseModel<GetRSAKeyRspModel>) -> Void) {
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let reqPrams: NSDictionary = [:]

        HttpUtils.post(url: PropertyUtils.getApiUrl("phi.server.url.getKey", domain: serverUrl), headerEntries: headerEntries, jsonData: reqPrams.serialize()) { _, data, error in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        }
    }
    
    // 未登入時需要拿到idToken才能發送Register API.
    // Keycloak.v1.batch-login
    func batchLogin(keycode: String = CommonSettings.KeycloakCode, requestCompleted: @escaping (PhiResponseModel<BatchLoginRspModel>) -> Void) {
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let reqPrams: NSDictionary = [
            "keycode": keycode
        ]

        HttpUtils.post(url: PropertyUtils.getApiUrl("Keycloak.v1.batch-login", domain: serverUrl), headerEntries: headerEntries, jsonData: reqPrams.serialize()) { _, data, error in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        }
    }
}
