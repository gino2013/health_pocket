//
//  PhiResponseModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/29.
//

import Foundation

public class PhiResponseModel<T: JSONDecodable>: JSONDecodable {

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
        errorCode = json["returnCode"].stringValue
        message = json["returnDesc"].stringValue
        
        if let errorCode = errorCode {
            if errorCode == "0000" {
                success = true
            }
        } else {
            success = errorCode == nil ? true : false
        }

        var subJson = json
        if json["returnData"].exists() {
            subJson = json["returnData"]
        } else {
            // process timeout error
            errorCode = json["errorCode"].stringValue
            message = json["message"].stringValue
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
