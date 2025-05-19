//
//  SDKManager.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/11/01.
//

import Foundation

class SDKManager {
    static let sharedInstance = SDKManager()
    static let sdk: PHI_SDKAPI = PHI_SDKAPI(clientID: "ios-app", channel: .dev)
    static let ezclaimSdk: EzclaimPartnerAPI = EzclaimPartnerAPI(clientID: "ios-app", channel: .dev)
    
    private init() {
        // PHI_SDK.setLogLevel(level: HardCode.logLevel)
    }
    
    /*
    func userLogin(requestData: UserLoginRequestData,
                   completionHandler: @escaping ((Bool, ResponseData?, String, NSError?) -> Void)) -> Void {
    }
     */
}
