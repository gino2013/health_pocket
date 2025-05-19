//
//  GetNotifListModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/17.
//

import Foundation

/*
 Request body：
 {
   "page": -1,               <--重取第零頁資料
   "queryTime": null         <--可不傳
 }
 或是
 {
   "page": 1,                <--取第壹頁資料
   "queryTime": "2024/07/14 21:33:16"  <--將上次的查詢時間回傳
 }
 */

struct GetNotifListModel {
    let page: Int
    let queryTime: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["page"].int = page
        json["queryTime"].string = queryTime
        return json
    }
    
    init(page: Int, queryTime: String) {
        self.page = page
        self.queryTime = queryTime
    }
}
