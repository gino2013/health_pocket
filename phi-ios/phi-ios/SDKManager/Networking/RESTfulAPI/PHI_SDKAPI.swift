//
//  PHI_SDKAPI.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation
import UIKit

@objc enum PHI_SDK_Channel: Int {
    case dev
    case stage
    case softlaunch
    case production
}

@objcMembers
class PHI_SDKAPI: NSObject {
    let clientID: String
    let channel: PHI_SDK_Channel
    
    public init(clientID: String!, channel: PHI_SDK_Channel) {
        self.clientID = clientID
        self.channel = channel
    }
    
    var serverUrl: String {
        let domain: String
        
        switch self.channel {
        case .dev, .stage:
            domain = "https://api.sit.openhealth2b.pro/phi-gl"
        case .softlaunch:
            domain = "https://identitytoolkit.googleapis.com/v1"
        case .production:
            domain = "https://identitytoolkit.googleapis.com/v2"
        }
        
        return domain
    }
    
    /* 登入 loginByToken */
    public func loginByToken(userToken: String, requestCompleted: @escaping (ResponseModel<MemberRspModel>) -> Void) {
        let headerEntries = ["Authorization": userToken]
        let loginPrams: NSDictionary = ["clientUuid": UIDevice.current.identifierForVendor!.uuidString, "clientUserAgent": "iOS"]

        HttpUtils.post(url: PropertyUtils.getApiUrl("server.url.session") + "/loginToken", headerEntries: headerEntries, jsonData: loginPrams.serialize()) { _, data, error in
            let json = JSON.parse(data: data, error: error)
            requestCompleted(ResponseModel(json: json))
        }
    }

    /* 登出 */
    public func logout(userToken: String, requestCompleted: @escaping () -> Void) {
        let headerEntries = ["Authorization": userToken]

        HttpUtils.delete(url: PropertyUtils.getApiUrl("server.url.session"), headerEntries: headerEntries) { _, _, _ in
            requestCompleted()
        }
    }
    
    /* 登入 For Firebase Test */
    func login(customerName: String, olaaword: String, uuid: String, requestCompleted: @escaping (ResponseModel<MemberRspModel>) -> Void) {
        let loginPrams: NSDictionary = [
            "email": customerName,
            "password": olaaword,
            "returnSecureToken": true
        ]

        HttpUtils.post(url: PropertyUtils.getApiUrl("server.url.session", domain: serverUrl) + "?key=\(Environment.firebaseAPIKey)", jsonData: loginPrams.serialize()) { _, data, error in
           
            let json = JSON.parse(data: data, error: error)
            requestCompleted(ResponseModel(json: json))
        }
    }
}
