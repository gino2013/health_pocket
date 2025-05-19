//
//  JSONSerializable.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class JSONSerializable: JSONEncodable {
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
            // print(childObj.dynamicType)
            if childObj is JSONSerializable {
                var subContainer = [String: AnyObject]()
                toDictionary(mirror: Mirror(reflecting: childObj), container: &subContainer)
                container[key!] = subContainer as AnyObject?
            } else if child is NSArray {
                var objectArray = [AnyObject]()
                let array = child as? NSArray
                if array != nil && array?.count > 0 {
                    for obj in array! {
                        if obj is JSONSerializable {
                            var subContainer = [String: AnyObject]()
                            toDictionary(mirror: Mirror(reflecting: obj), container: &subContainer)
                            objectArray.append(subContainer as AnyObject)
                        } else {
                            objectArray.append(obj as AnyObject)
                        }
                    }
                }
                container[key!] = objectArray as AnyObject?
            } else if let superMirror = mirror.superclassMirror {
                toDictionary(mirror: superMirror, container: &container)
            }
        }
    }

    func serialize() -> Data? {
        return toDictionary().serialize() as Data?
    }
}
