//
//  PharmacyMapInfoRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/11.
//

import Foundation

/*
 "pharmacys": [
       {
         "id": "14736a3dc9d61676b98f961f718883f2",
         "code": null,
         "name": "仕德安藥局",
         "address": "臺北市內湖區新明路２１０號",
         "contactPhone": "(02)27961683",
         "businessHours": [
           "星期一: 09:00 – 22:00",
           "星期二: 09:00 – 22:00",
           "星期三: 09:00 – 22:00",
           "星期四: 09:00 – 22:00",
           "星期五: 09:00 – 22:00",
           "星期六: 09:00 – 22:00",
           "星期日: 09:00 – 22:00"
         ],
         "latitude": 25.041,
         "longitude": 121.565,
         "isPartner": false,
         "isLastReceive": false,
         "distance": 0.3
       },
 ]
 */

class PharmacyMapInfoRspModel: JSONDecodable {
    var id: String
    var code: String
    var name: String
    var address: String
    var contactPhone: String
    var businessHours: Array<String>
    var latitude: Double
    var longitude: Double
    var isPartner: Bool
    var isLastReceive: Bool
    var distance: Double
    
    required init(json: JSON) {
        id = json["id"].stringValue
        code = json["code"].stringValue
        name = json["name"].stringValue
        address = json["address"].stringValue
        contactPhone = json["contactPhone"].stringValue
        
        var businessHoursArray = [String]()
        for (_, hourObj): (String, JSON) in json["businessHours"] {
            businessHoursArray.append(hourObj.stringValue)
        }
        businessHours = businessHoursArray
        
        latitude = json["latitude"].doubleValue
        longitude = json["longitude"].doubleValue
        isPartner = json["isPartner"].boolValue
        isLastReceive = json["isLastReceive"].boolValue
        distance = json["distance"].doubleValue
    }
}
