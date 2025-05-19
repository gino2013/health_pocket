//
//  ResponseModel.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

public class ResponseModel<T: JSONDecodable>: JSONDecodable {

    public var success: Bool = false
    public var errorCode: String?
    public var message: String?
    public var data: T?

    init(success: Bool, errorCode: String? = nil, message: String? = nil, data: T? = nil) {
        self.success = success
        self.errorCode = errorCode
        self.message = message
        self.data = data
    }

    required public init(json: JSON) {
        let errorContent = json["error"]
        
        errorCode = errorContent["code"].stringValue
        message = errorContent["message"].stringValue
        //errorCode = json["errorCode"].string
        //message = json["message"].stringValue

        // It's possible there is no response model wrapping on JSON format.
        if let isSuccessful = json["success"].bool {
            success = isSuccessful
        } else {
            success = errorCode == nil ? true : false
            
            if let errorCode = errorCode {
                if errorCode.count == 0 {
                    success = true
                }
            }
        }

        var subJson = json
        if json["value"].exists() {
            subJson = json["value"]
        }

        data = T(json: subJson)

        errorHandler()
    }

    func errorHandler() {
        if let error = errorCode {
            if let e = ErrorCode(rawValue: error) {
                switch e {
                case .runtimeException, .unknowException:
                    /*
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.UnexpectedErrorEvent),
                                                    object: self,
                                                    userInfo: [NotificationKey.UnexpectedErrorEvent: message ?? ""])
                     */
                    break
                default:
                    break
                }
            }
        }
    }
}
