//
//  HealthViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/29.
//

import UIKit

/*
// 寫入單筆資料
let healthKit = HealthKitManager.shared
let steps = 1000.0
let date = Date()

healthKit.saveHealthData(type: .steps, value: steps, date: date) { success, error in
    if success {
        print("成功寫入步數資料")
    } else {
        print("寫入失敗：\(error?.localizedDescription ?? "unknown error")")
    }
}

// 批量寫入資料
let dataPoints = [
    HealthDataPoint(date: Date(), value: 1000),
    HealthDataPoint(date: Date().addingTimeInterval(3600), value: 2000)
]

healthKit.saveBulkHealthData(type: .steps, dataPoints: dataPoints) { success, error in
    if success {
        print("成功批量寫入步數資料")
    } else {
        print("批量寫入失敗：\(error?.localizedDescription ?? "unknown error")")
    }
}
*/

// MARK: - ViewModel
class HealthViewModel {
    private let healthKitManager = HealthKitManager.shared
    
    // 回調閉包
    var onDataUpdate: (([HealthDataPoint]) -> Void)?
    var onError: ((Error) -> Void)?
    var onAuthorizationComplete: ((Bool) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private(set) var isLoading = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    func requestHealthKitPermission() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            if let error = error {
                self?.onError?(error)
                return
            }
            self?.onAuthorizationComplete?(success)
        }
    }
    
    func fetchHealthData(type: HealthDataType, startDate: Date, endDate: Date) {
        isLoading = true
        
        healthKitManager.fetchHealthData(
            for: type.quantityType,
            unit: type.unit,
            startDate: startDate,
            endDate: endDate
        ) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let dataPoints):
                self?.onDataUpdate?(dataPoints)
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
