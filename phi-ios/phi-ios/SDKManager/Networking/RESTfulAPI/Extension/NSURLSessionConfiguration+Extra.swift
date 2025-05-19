//
//  NSURLSessionConfiguration+Extra.swift
//  Networking
//
//  Created by Kenneth Wu on 3/11/2016.
//  Copyright (c) 2016 X. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
    /// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised
    /// from the default to your requirements.
    class func noCacheConfigurationWithTimeout(_ timeout: TimeInterval) -> URLSessionConfiguration {
        let config = `default`
        config.timeoutIntervalForRequest = timeout // Make things timeout quickly.
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return config
    }
}
