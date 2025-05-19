//
//  Environment+DEV.swift
//  SDK
//
//  Created by Kenneth on 2023/10/5.
//

import Foundation

extension Environment {
    #if DEBUG
        // Server
        //static let defaultServerDomainUrl = "https://parseapi.back4app.com"
        static let defaultServerDomainUrl = "https://identitytoolkit.googleapis.com/v1"
        static let serverDomainListUrl = URL(string: "https://download.hhc.dev.com/mobile/server-url.txt")!

        // GA
        static let gaServerDomainUrl = "https://identitytoolkit.googleapis.com/v1"
        static let gaTrackingId = "UA-72036916-4"

        // Download
        static let manifestUrl = URL(string: "https://download.hhc.dev.com/mobile/ios/ub8-ios.plist")!
        static let downloadUrl = URL(string: "itms-services://?action=download-manifest&url=https://download.hhc.dev.com/mobile/ios/ub8-ios.plist")!

        // JPush
        static let jpushAppKey = "ac4f5b1eef5eaed0a3db5551"
        static let jpushProduction = false

    #endif
}
