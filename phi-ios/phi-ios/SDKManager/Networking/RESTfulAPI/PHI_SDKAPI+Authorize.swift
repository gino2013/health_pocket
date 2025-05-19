//
//  PHI_SDKAPI+Authorize.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/7.
//

import Foundation
import UIKit
import KeychainSwift

extension PHI_SDKAPI {
    /* 取得可以授權之醫院清單 取得合作夥伴清單 */
    func getMedicalPartnerList(_ idTokenForAPI: String, requestCompleted: @escaping (PhiResponseModel<MedicalPartnerListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.findMedicalPartner", domain: serverUrl)
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
    
    /* 取得已授權合作夥伴清單 */
    func getAuthorizedPartnerList(_ idTokenForAPI: String, requestCompleted: @escaping (PhiResponseModel<MedicalPartnerListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.findAuthorizedPartner", domain: serverUrl)
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
    
    /* 取得可授權的醫療科別 */
    func findMedicalDept(postModel: FindMedicalDeptModel, requestCompleted: @escaping (PhiResponseModel<MedicalDeptListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.findMedicalDept", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 取得已授權之醫療授權 */
    func findMedicalAuth(postModel: FindMedicalDeptModel, requestCompleted: @escaping (PhiResponseModel<MedicalAuthRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.findMedicalAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 設定醫療授權 */
    func setupMedicalAuth(postModel: SetupMedicalAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.setupMedicalAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON() as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 重設醫療授權 */
    func resetMedicalAuth(postModel: SetupMedicalAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.resetMedicalAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON() as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 刪除指定的醫療授權 */
    func deleteMedicalAuth(postModel: DeleteMedicalAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.deleteMedicalAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary
        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    // 0617_2024,
    /* 取得失效醫療授權 */
    func getExpiredMedAuthList(_ idTokenForAPI: String, requestCompleted: @escaping (PhiResponseModel<ExpiredMedAuthListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.listExpiredMedAuth", domain: serverUrl)
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
    
    /* 停止醫療授權 */
    func terminateMedicalAuth(postModel: SetupExpiredMedicalAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.terminateMedAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON() as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 展延醫療授權 */
    func extendMedicalAuth(postModel: SetupExpiredMedicalAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.extendMedAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON() as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 計數到期醫療授權 */
    func getCountExpiredMedAuth(_ idTokenForAPI: String, requestCompleted: @escaping (PhiResponseModel<CountExpiredMedicalRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.countExpiredMedAuth", domain: serverUrl)
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
    
    /* 檢查有效醫療授權 */
    func checkEffectiveMedicalAuth(_ idTokenForAPI: String, requestCompleted: @escaping (PhiResponseModel<CheckEffMedAuthRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.checkEffectiveMedicalAuth", domain: serverUrl)
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
    
    /* 處理複合式醫療授權 */
    func handleMedicalAuth(postModel: HandleExpiredMedAuthModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.handleMedicalAuth", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON() as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
}
