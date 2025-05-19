//
//  PHI_SDKAPI+Reminder.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation
import UIKit
import KeychainSwift

extension PHI_SDKAPI {
    /* 查詢全部提醒記錄 */
    func getReminderRecords(_ postModel: GetReminderRecordsModel, requestCompleted: @escaping (PhiResponseModel<ReminderRecordGroupRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getReminderRecords", domain: serverUrl)
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
    
    /* 新建多筆提醒設定 */
    func createReminderSettings(_ postModel: CreateReminderSettingModel, requestCompleted: @escaping (PhiResponseModel<ReminderSettingIdRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.createReminderSettings", domain: serverUrl)
        let idTokenForAPI: String = KeychainSwift().get("idToken") ?? ""
        let headerEntries = ["Txnseq": "123456789",
                             "Tenant-Id": CommonSettings.TenantId,
                             "Client": CommonSettings.httpRequestHeaderClient,
                             "Id-Token": "Bearer \(idTokenForAPI)"]
        let reqPrams: [NSDictionary] = postModel.toNSDictionaryArray()

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(PhiResponseModel(json: json))
        })
    }
    
    /* 查詢多筆提醒設定 */
    func getReminderSetting(postModel: GetReminderSettingModel, requestCompleted: @escaping (PhiResponseModel<ReminderSettingRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getReminderSetting", domain: serverUrl)
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
    
    /* 修改多筆提醒設定 */
    func modifyReminderSetting(_ postModel: ModifyReminderSettingModel, requestCompleted: @escaping (PhiResponseModel<ModifyReminderSettingRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.ModifyReminderSetting", domain: serverUrl)
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
    
    /* 刪除多筆提醒設定 */
    func deleteReminderSetting(_ postModel: DelReminderSettingIdModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.DeleteReminderSetting", domain: serverUrl)
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
    
    /* 新建單次提醒設定 */
    func createReminderSingleTimeSetting(_ postModel: CreateSingleReminderSettingModel, requestCompleted: @escaping (PhiResponseModel<ReminderSettingIdInfoRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.CreateSingleReminderSetting", domain: serverUrl)
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
    
    /* 修改單次提醒設定 */
    func modifyReminderSingleTimeSetting(_ postModel: ModifySingleReminderSettingModel, requestCompleted: @escaping (PhiResponseModel<ReminderSettingIdInfoRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.ModifySingleReminderSetting", domain: serverUrl)
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
    
    /* 建立單次用藥提醒結果 */
    func createReminderRecordMedicineInfo(_ postModel: CreateReminderRecordModel, requestCompleted: @escaping (PhiResponseModel<ReminderRecordInfoRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.CreateReminderRecoedMedInfo", domain: serverUrl)
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
    
    /* 恢復單次用藥提醒結果 */
    func deleteReminderRecordMedicineInfo(_ postModel: DeleteReminderRecordModel, requestCompleted: @escaping (PhiResponseModel<ReminderRecordInfoRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.DeleteReminderRecoedMedInfo", domain: serverUrl)
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
    
    /* 取得應已提醒記錄更新到通知中心並回傳未來提醒 */
    func syncAndGetReminderNotifications(requestCompleted: @escaping (PhiResponseModel<SyncReminderNotifRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.SyncReminderNotifications", domain: serverUrl)
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
    
    /* 取得作息時間 */
    func findRoutineTime(requestCompleted: @escaping (PhiResponseModel<RoutineTimeInfoRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.FindRoutineTime", domain: serverUrl)
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
    
    /* 設定作息時間 */
    func setRoutineTime(_ postModel: SetupRoutineTimeModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.SetRoutineTime", domain: serverUrl)
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
}
