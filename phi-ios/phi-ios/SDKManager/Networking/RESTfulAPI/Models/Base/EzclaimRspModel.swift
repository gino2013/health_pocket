//
//  EzclaimRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation

public class EzclaimRspModel<T: JSONDecodable>: JSONDecodable {
    public var success: Bool = false
    public var errorCode: String?
    public var message: String?
    public var data: [T]?  // data 是一個數組

    init(success: Bool, errorCode: String? = nil, message: String? = nil, data: [T]? = nil) {
        self.success = success
        self.errorCode = errorCode
        self.message = message
        self.data = data
    }

    required public init(json: JSON) {
        errorCode = "\(json["code"].intValue)"
        message = json["message"].stringValue
        
        if let errorCode = errorCode {
            if errorCode == "0" {
                success = true
            }
        } else {
            success = false
        }
        
        // 解析 data 數組，確保 data 存在並且是數組
        if let dataArray = json["data"].array {
            // 將數組中的每一個元素進行解碼
            data = dataArray.map { T(json: $0) }
        } else {
            data = nil
        }
        
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
