//
//  Environment.swift
//  SDK
//
//  Created by Kenneth on 2023/10/5.
//

import Foundation

enum Environment {
    // GA
    static let gaDispatchInterval: TimeInterval = 300

    // Customer Service
    static let customerServiceMail = "cs@hhc_dev.com"
    static let defaultCustomerServiceURL = "https://hhc_dev.com/new/client.php?"
        + "values=Tp5r+qTWWNoETuA2oPNT/K37nA71spQI0umyg8blE39vNhl+tQEgIA/zRWs8t4ybBm"
        + "n+1ajZePYrW+bWJnXwrgIJyC+Ziuof3wMVBGh5MgcfrbD7i4Y/9qJq5G7JAT58sxu36P+kzI4="
    
    static let firebaseAPIKey = "AIzaSyDbLC1wYZbPB8TzSBVzIfAE0F5pRcK98Rc"
}
