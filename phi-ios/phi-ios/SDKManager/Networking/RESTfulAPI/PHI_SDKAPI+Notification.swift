//
//  PHI_SDKAPI+Notification.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/17.
//

import Foundation
import UIKit
import KeychainSwift

extension PHI_SDKAPI {
    /* 儲存推播token */
    func requestSaveAPNSToken(_ postModel: SaveAPNSTokenModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.saveAPNSToken", domain: serverUrl)
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
    
    /* 計數未讀推播通知 */
    func getCountUnreadNotification(requestCompleted: @escaping (PhiResponseModel<CountUnreadNotifRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.countUnreadNotification", domain: serverUrl)
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
    
    /* 取得推播通知清單 */
    func getNotificationList(postModel: GetNotifListModel, requestCompleted: @escaping (PhiResponseModel<NotificationListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.listNotification", domain: serverUrl)
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
    
    /* 更新推播通知狀態為已讀 */
    func requestMarkNotification(_ postModel: MarkNotificationModel, requestCompleted: @escaping (PhiResponseModel<NullModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.markNotification", domain: serverUrl)
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
