//
//  MedHistoryTViewCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/13.
//

import Foundation

struct MedHistoryTViewCellViewModel {
    // Top View
    let hospitalName: String
    let type: String
    let nthReceiveTime: String
    let date: String
    // Bottom View
    let name: String
    let diseaseType: String
    let dateRange: String
    let rcvStatus: String
    var rcvStatusDesc: String
    let tenantId: String
    let prescriptionId: String
    let isPrescriptionEnded: Bool
    var expanded: Bool
}

func sampleData() -> [MedHistoryTViewCellViewModel] {
    var a = [MedHistoryTViewCellViewModel]()
    a.append(MedHistoryTViewCellViewModel(hospitalName: "----", type: "--", nthReceiveTime: "-----", date: "----/--/--", name: "---", diseaseType: "-----", dateRange: "----/--/--", rcvStatus: "-", rcvStatusDesc: "---", tenantId: "-----", prescriptionId:"-----", isPrescriptionEnded: false, expanded: false))
    /*
    a.append(MedHistoryTViewCellViewModel(hospitalName: "國泰醫院", type: "門診", nthReceiveTime: "第2次領藥", date: "2023/12/15", name: "吳明忠", diseaseType: "第一型糖尿病", dateRange: "2023/12/01-2024/3/1", status: "可領藥", tenantId: "2344266634", prescriptionId:"AC004", expanded: true))
    a.append(MedHistoryTViewCellViewModel(hospitalName: "參天醫院", type: "門診", nthReceiveTime: "第1次領藥", date: "2024/05/01", name: "吳明忠", diseaseType: "第二型糖尿病", dateRange: "2023/12/01-2024/3/1", status: "已預約", tenantId: "2355266634", prescriptionId:"AC114", expanded: false))
    a.append(MedHistoryTViewCellViewModel(hospitalName: "參天上醫院", type: "門診", nthReceiveTime: "第2次領藥", date: "2023/12/15", name: "吳明忠", diseaseType: "第一型感冒", dateRange: "2023/12/01-2024/3/1", status: "可領藥", tenantId: "2344255534", prescriptionId:"AC904", expanded: false))
    a.append(MedHistoryTViewCellViewModel(hospitalName: "長庚醫院", type: "門診", nthReceiveTime: "第1次領藥", date: "2023/12/15", name: "吳明忠", diseaseType: "第一型心臟病", dateRange: "2023/12/01-2024/3/1", status: "已預約", tenantId: "2344233334", prescriptionId:"AC504", expanded: false))
    a.append(MedHistoryTViewCellViewModel(hospitalName: "和平醫院", type: "門診", nthReceiveTime: "第2次領藥", date: "2023/12/15", name: "吳明忠", diseaseType: "牙痛", dateRange: "2023/12/01-2024/3/1", status: "可領藥", tenantId: "2366266644", prescriptionId:"AC114", expanded: false))
    a.append(MedHistoryTViewCellViewModel(hospitalName: "測試醫院", type: "門診", nthReceiveTime: "第1次領藥", date: "2023/12/15", name: "吳明忠", diseaseType: "第一型腎臟病", dateRange: "2023/12/01-2024/3/1", status: "已預約", tenantId: "2374766634", prescriptionId:"AC774", expanded: false))
     */
    return a
}
