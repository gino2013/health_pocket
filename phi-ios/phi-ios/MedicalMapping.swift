//
//  MedicalMapping.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/16.
//

import Foundation

let medicalTypeMapping = ["1": "門診",
                          "2": "運動課程"]
let takingTimeTypeMapping = ["飯前": "AC",
                             "飯後": "PC",
                             "睡前": "HS",
                             "飯後、睡前": "PCHS",
                             "飯前、睡前": "ACHS",
                             "其他時段": "OTHER"]
let usageDictMapping = ["每日一次": 1,
                        "每日二次": 2,
                        "每日三次": 3,
                        "每日四次": 4,
                        "每週一次": 1,
                        "每週二次": 2,
                        "每週三次": 3,
                        "其它時段": -1]
let takingTimeCodeMapping = ["AC": "飯前",
                             "PC": "飯後",
                             "HS": "睡前",
                             "PCHS": "飯後、睡前",
                             "ACHS": "飯前、睡前",
                             "OTHER": "其他時段"]
let weekDaysArray = ["週一", "週二", "週三", "週四", "週五", "週六", "週日"]
let weekDaysMapping = ["週一": "1", "週二": "2", "週三": "3", "週四": "4", "週五": "5", "週六": "6", "週日": "7"]
