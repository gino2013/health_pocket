//
//  PHI_SDKAPI+Prescription.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/14.
//

import Foundation
import KeychainSwift

extension PHI_SDKAPI {
    /* 取得醫療歷程資料與處方簽 */
    func getMedRecordWithPrescription(postModel: GetMedRecWithPrescriptionModel, requestCompleted: @escaping (PhiResponseModel<MedicalRecordListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getEncountersWithPrescription", domain: serverUrl)
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
    
    /* 取得處方簽與處方藥資料 */
    func getPrescriptionMedicines(postModel: GetPrescriptionModel, requestCompleted: @escaping (PhiResponseModel<MedicinesListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescriptionMedicines", domain: serverUrl)
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
    
    /* 取得處方簽領藥記錄資料清單 */
    func getReceiveRecords(postModel: GetPrescriptionModel, requestCompleted: @escaping (PhiResponseModel<ReceiveRecordListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescriptionRecoeds", domain: serverUrl)
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
    
    /* 取得處方簽單次領藥記錄詳細資料清單 */
    func getReceiveRecordsDetail(postModel: GetReceiveRecordDetailModel, requestCompleted: @escaping (PhiResponseModel<ReceiveRecordDetailRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescriptionRecoedsDetail", domain: serverUrl)
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
    
    /* 取得處方簽詳細資料 */
    func getPrescription(postModel: GetPrescriptionModel, requestCompleted: @escaping (PhiResponseModel<PrescriptionDetailRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescription", domain: serverUrl)
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
    
    /* 取得處方簽QRCode */
    func getPrescriptionQRCode(postModel: GetPrescriptionModel, requestCompleted: @escaping (PhiResponseModel<PrescriptionQRCodeRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescriptionMedicinesQrcode", domain: serverUrl)
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
    
    /* 取得藥局清單 */
    func searchPharmacy(postModel: SearchPharmacyModel, requestCompleted: @escaping (PhiResponseModel<PharmacyMapInfoListRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.searchPharmacy", domain: serverUrl)
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
    
    /* 手動新增領藥完成記錄 */
    func prescriptionReceive(postModel: PrescriptionReceiveModel, requestCompleted: @escaping (PhiResponseModel<PrescriptionReceiveRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.prescriptionReceive", domain: serverUrl)
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
    
    /* 送出或取消預約 */
    func prescriptionReservation(postModel: PrescriptionReservationModel, requestCompleted: @escaping (PhiResponseModel<PrescriptionReservationRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.prescriptionReservation", domain: serverUrl)
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
    
    /* 取得全部處方箋狀態 */
    func getPrescriptionStatus(postModel: GetPrescriptionStatusModel, requestCompleted: @escaping (PhiResponseModel<PrescriptionStatusRspModel>) -> Void) {
        let apiUrl = PropertyUtils.getApiUrl("phi.server.url.getPrescriptionsStatus", domain: serverUrl)
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
