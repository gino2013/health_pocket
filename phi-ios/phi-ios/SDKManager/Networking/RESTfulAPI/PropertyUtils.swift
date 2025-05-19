//
//  PropertyUtils.swift
//  SDK
//
//  Created by Kenneth on 2023/10/5.
//

import Foundation

class PropertyUtils {
    // for SDK use
    // static var appSettings = NSDictionary(contentsOfFile: Bundle(identifier: "com.hhc.sdk.BundleID")!.path(forResource: "app_settings", ofType: "plist")!) as? Dictionary<String, String>
    static var appSettings = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "app_settings", ofType: "plist")!) as? Dictionary<String, String>
            
    static func getServerRoot() -> URL? {
        guard let domain = URL(string: Environment.defaultServerDomainUrl) else {
            return nil
        }

        return domain
    }

    static func getApiUrl(_ key: String, params: CVarArg...) -> String {
        guard let domain = getServerRoot() else {
            return ""
        }

        let path = String(format: readAppSettings(key), arguments: params)
        return domain.appendingPathComponent(path).absoluteString
    }

    static func getApiUrl(_ key: String, domain: String, params: CVarArg...) -> String {
        guard let domainURL = URL(string: domain) else {
            return ""
        }

        let path = String(format: readAppSettings(key), arguments: params)
        return domainURL.appendingPathComponent(path).absoluteString
    }
    
    static func getGAApiUrl(_ key: String, params: CVarArg...) -> String {
        guard let domain = URL(string: Environment.gaServerDomainUrl) else {
            return ""
        }

        let path = String(format: readAppSettings(key), arguments: params)
        return domain.appendingPathComponent(path).absoluteString
    }

    static func readAppSettings(_ key: String) -> String! {
        return appSettings![key]
    }

    static func readLocalizedProperty(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    static func readLocalizedPropertyWithArgs(_ key: String, args: [CVarArg]) -> String {
        return String(format: NSLocalizedString(key, comment: ""), arguments: args)
    }
}
