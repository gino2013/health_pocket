//
//  HealthDataViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/24.
//

import HealthKit
import Combine

class HealthDataViewModel: ObservableObject {
    private var healthKitService = HealthKitService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var stepCountData: [HKQuantitySample] = []
    @Published var errorMessage: String?

    // 請求授權
    func requestHealthKitAuthorization() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let readTypes: Set<HKObjectType> = [stepCountType]
        healthKitService.requestAuthorization(toRead: readTypes) { (success, error) in
            if !success {
                self.errorMessage = "HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")"
            }
        }
    }

    // 讀取步數資料
    func fetchStepCount(startDate: Date, endDate: Date) {
        healthKitService.readStepCount(startDate: startDate, endDate: endDate)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                }
            }, receiveValue: { samples in
                self.stepCountData = samples
            })
            .store(in: &cancellables)
    }
}
