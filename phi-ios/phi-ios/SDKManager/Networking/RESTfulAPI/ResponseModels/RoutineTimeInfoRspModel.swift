//
//  RoutineTimeInfoRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/7.
//

import Foundation

/*
 "returnData": {
     "id": 0,
     "breakfastTime": "string",
     "lunchTime": "string",
     "dinnerTime": "string",
     "bedtimeTime": "string",
     "mealBefore": 0,
     "mealAfter": 0,
     "bedtimeBefore": 0
}
 */

class RoutineTimeInfoRspModel: JSONDecodable {
    public var id: Int
    public var breakfastTime: String
    public var lunchTime: String
    public var dinnerTime: String
    public var bedtimeTime: String
    public var mealBefore: Int
    public var mealAfter: Int
    public var bedtimeBefore: Int
    
    required init(json: JSON) {
        id = json["id"].intValue
        breakfastTime = json["breakfastTime"].stringValue
        lunchTime = json["lunchTime"].stringValue
        dinnerTime = json["dinnerTime"].stringValue
        bedtimeTime = json["bedtimeTime"].stringValue
        mealBefore = json["mealBefore"].intValue
        mealAfter = json["mealAfter"].intValue
        bedtimeBefore = json["bedtimeBefore"].intValue
    }
}
