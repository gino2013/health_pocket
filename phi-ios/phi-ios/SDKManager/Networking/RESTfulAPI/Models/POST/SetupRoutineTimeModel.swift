//
//  SetupRoutineTimeModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/8/7.
//

import Foundation

/*
 req
 {
   "breakfastTime": "08:00",
   "lunchTime": "12:00",
   "dinnerTime": "18:30",
   "bedtimeTime": "21:30",
   "mealBefore": 30,
   "mealAfter": 30,
   "bedtimeBefore": 30
 }
*/

struct SetupRoutineTimeModel {
    let breakfastTime: String
    let lunchTime: String
    let dinnerTime: String
    let bedtimeTime: String
    let mealBefore: Int
    let mealAfter: Int
    let bedtimeBefore: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["breakfastTime"].string = breakfastTime
        json["lunchTime"].string = lunchTime
        json["dinnerTime"].string = dinnerTime
        json["bedtimeTime"].string = bedtimeTime
        json["mealBefore"].int = mealBefore
        json["mealAfter"].int = mealAfter
        json["bedtimeBefore"].int = bedtimeBefore
        
        return json
    }
    
    init(breakfastTime: String, lunchTime: String, dinnerTime: String, bedtimeTime: String, mealBefore: Int, mealAfter: Int, bedtimeBefore: Int) {
        self.breakfastTime = breakfastTime
        self.lunchTime = lunchTime
        self.dinnerTime = dinnerTime
        self.bedtimeTime = bedtimeTime
        self.mealBefore = mealBefore
        self.mealAfter = mealAfter
        self.bedtimeBefore = bedtimeBefore
    }
}
