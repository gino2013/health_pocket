//
//  JSONExtension.swift
//  Networking
//
//  Created by Kenneth Wu on 3/11/2016.
//  Copyright (c) 2016 X. All rights reserved.
//

import Foundation

extension JSON {
    static func failedResponseJSON(_ error: Error?) -> JSON {
        var json: JSON = [:]
        json["success"].bool = false

        if let err = error {
            json["errorCode"].string = String((err as NSError).code)
            json["message"].string = err.localizedDescription
        } else {
            json["errorCode"].string = String()
            json["message"].string = "JSON response data is empty, response error is nil."
        }

        return json
    }

    static func parse(data: Data?, error: Error?) -> JSON {
        var json: JSON = JSON.failedResponseJSON(error)

        if let raw = data, let parsed = try? JSON(data: raw) {
            json = parsed
        }

        return json
    }
}

extension JSON {
    public var dateByTimestamp: Date? {
        guard let val = self.double else {
            return nil
        }

        return Date(timeIntervalSince1970: val / 1000.0)
    }

    public var intBoolValue: Bool {
        return intValue == 0 ? false : true
    }
}
