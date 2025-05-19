//
//  HealthInfoViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/24.
//

import HealthKit

class HealthInfoViewModel {
    private let healthKitService = HealthKitService()
    var stepCountData: [HKQuantitySample] = []
    var errorMessage: String?
    
    // 請求授權
    func requestHealthKitAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let readTypes: Set<HKObjectType> = [stepCountType]
        healthKitService.requestAuthorization(toRead: readTypes, completion: completion)
    }
    
    // 讀取步數資料
    func fetchStepCount(startDate: Date, endDate: Date, completion: @escaping () -> Void) {
        healthKitService.readStepCountClosure(startDate: startDate, endDate: endDate) { result in
            switch result {
            case .success(let samples):
                self.stepCountData = samples
            case .failure(let error):
                self.errorMessage = "Failed to load data: \(error.localizedDescription)"
            }
            completion()
        }
    }
}
