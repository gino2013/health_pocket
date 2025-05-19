//
//  EzclaimPartnerAPI.swift
//  SDK
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation
import UIKit
import KeychainSwift

@objc enum EzclaimPartnerAPI_Channel: Int {
    case dev
    case stage
    case softlaunch
    case production
}

@objcMembers
class EzclaimPartnerAPI: NSObject {
    let clientID: String
    let channel: EzclaimPartnerAPI_Channel
    
    public init(clientID: String!, channel: EzclaimPartnerAPI_Channel) {
        self.clientID = clientID
        self.channel = channel
    }
    
    var serverUrl: String {
        let domain: String
        
        switch self.channel {
        case .dev, .stage:
            domain = "\(ezClaimIP):8080/ezclaimPartner"
        case .softlaunch:
            domain = "\(ezClaimIP):8080/ezclaimPartner"
        case .production:
            domain = "\(ezClaimIP):8080/ezclaimPartner"
        }
        
        return domain
    }
    
    // 4 取得JWT Token /api/open/login4Jwt/signin
    func login4JwtSignin(_ postModel: GetJwtTokenModel, requestCompleted: @escaping (EzclaimRspModel<JwtTokenRspModel>) -> Void) {
        let apiUrl = "\(ezClaimIP):8080/ezclaimPartner/api/open/login4Jwt/signin"
        let headerEntries = ["Client": CommonSettings.httpRequestHeaderClient]
        let loginPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  loginPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(EzclaimRspModel(json: json))
        })
    }

    // 2 下載保單商品清單 /api/insuranceproduct/simple
    func insuranceproductSimple(requestCompleted: @escaping (EzclaimRspModel<InsuranceProductRspModel>) -> Void) {
        let apiUrl = "\(ezClaimIP):8080/ezclaimPartner/api/insuranceproduct/simple"
        let bearerTokenForAPI: String = KeychainSwift().get("BearerToken") ?? ""
        let headerEntries = ["Client": CommonSettings.httpRequestHeaderClient,
                             "Authorization": "Bearer \(bearerTokenForAPI)"]
        HttpUtils.get(url: apiUrl, headerEntries: headerEntries, completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(EzclaimRspModel(json: json))
        })
    }
    
    // 3 下載疾病主檔清單 /api/diseaseclaimconfig/mytenant
    func diseaseclaimconfig(requestCompleted: @escaping (EzclaimRspModel<DiseaseclaimRspModel>) -> Void) {
        let apiUrl = "\(ezClaimIP):8080/ezclaimPartner/api/diseaseclaimconfig/mytenant"
        let bearerTokenForAPI: String = KeychainSwift().get("BearerToken") ?? ""
        let headerEntries = ["Client": CommonSettings.httpRequestHeaderClient,
                             "Authorization": "Bearer \(bearerTokenForAPI)"]

        HttpUtils.get(url: apiUrl, headerEntries: headerEntries, completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(EzclaimRspModel(json: json))
        })
    }
    
    // 1 理賠試算 /api/diseaseclaim/report
    func diseaseclaimReport(_ postModel: GetEzClaimReportModel, requestCompleted: @escaping (EzclaimRspModel<DiseaseclaimReportRspModel>) -> Void) {
        let apiUrl = "\(ezClaimIP):8080/ezclaimPartner/api/diseaseclaim/report"
        let bearerTokenForAPI: String = KeychainSwift().get("BearerToken") ?? ""
        let headerEntries = ["Client": CommonSettings.httpRequestHeaderClient,
                             "Authorization": "Bearer \(bearerTokenForAPI)"]
        let reqPrams: NSDictionary = postModel.toJSON().dictionaryObject! as NSDictionary

        HttpUtils.post(url: apiUrl, headerEntries: headerEntries, jsonData:  reqPrams.serialize(), completion: { (status, data, error) in
            
            let json = JSON.parse(data: data, error: error)
            requestCompleted(EzclaimRspModel(json: json))
        })
    }
}
