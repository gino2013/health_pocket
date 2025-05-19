//
//  PHI_SDKAPI+Member.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/7.
//

import Foundation
import UIKit
import KeychainSwift

extension PHI_SDKAPI {
    /* 修改密碼 */
    func requestUpdateMemberKeyCode(_ postModel: UpdateMemberKeyCodeModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.updateMemberKeyCode", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let updateMemberKeyCodeModelPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  updateMemberKeyCodeModelPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 重設密碼 */
    func requestResetMemberKeyCode(_ postModel: ResetMemberKeyCodeModel, requestCompleted: @escaping (PhiResponseModel<StringModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.resetMemberKeyCode", domain: serverUrl)
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let resetMemberKeyCodeModelPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  resetMemberKeyCodeModelPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 註冊 */
    func requestRegister(_ userToken: String, postModel: RegisterModel, requestCompleted: @escaping (PhiResponseModel<StringModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.register", domain: serverUrl)
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(userToken)"]
        let registerPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  registerPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 登入前檢核是否為會員 */
    func requestCheckMembership(_ postModel: CheckMembershipModel, requestCompleted: @escaping (PhiResponseModel<CheckMembershipRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.checkMembership", domain: serverUrl)
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient]
        let requestCheckMembershipPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  requestCheckMembershipPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 取得會員資料 */
    func requestFindMember(requestCompleted: @escaping (PhiResponseModel<MemberRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.findMember", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = [:]

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 更新行動裝置UUID */
    func requestUpdateMobileUUID(requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.mobileUUID", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = ["mobileUuid": UIDevice.current.identifierForVendor?.uuidString ?? ""]

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 更新會員資料 */
    func updateMemberInfo(_ postModel: UpdateMemberInfoModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.updateMember", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let requestCheckMembershipPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  requestCheckMembershipPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 檢核會員密碼 */
    func requestVerifyKeycode(_ keyCode: String, requestCompleted: @escaping (PhiResponseModel<VerifyKeycodeRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.verifyKeycode", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = ["keycode": keyCode]

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
}
