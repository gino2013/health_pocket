//
//  JSONQueryable.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

class JSONQueryable {
    fileprivate func toDictionary() -> NSDictionary {
        var container = [String: AnyObject]()
        let mirror = Mirror(reflecting: self)
        toDictionary(mirror: mirror, container: &container)
        return container as NSDictionary
    }

    fileprivate func toDictionary(mirror: Mirror, container: inout Dictionary<String, AnyObject>) {
        for (key, child) in mirror.children {
            let childObj = child as AnyObject
            container[key!] = childObj
            if let superMirror = mirror.superclassMirror {
                toDictionary(mirror: superMirror, container: &container)
            }
        }
    }

    func quary() -> String {
        let quaryDir = toDictionary()
        var quaryString = String()

        for (key, child) in quaryDir {
            let keyStr = key as! String
            let valueSte = String(describing: child)

            if quaryString.isEmpty {
                quaryString = String(format: "%@=%@", keyStr, valueSte)
            } else {
                quaryString.append(String(format: "&%@=%@", keyStr, valueSte))
            }
        }
        return quaryString
    }

    func encodeQuary(apiUrl: String) -> String {
        var url = apiUrl
        let query = quary()
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            url.append("?" + encodedQuery)
        }
        return url
    }
}
