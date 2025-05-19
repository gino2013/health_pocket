//
//  HealthKitService.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/24.
//

import HealthKit
import Combine

class HealthKitService {
    private let healthStore = HKHealthStore()
    
    // 確認 HealthKit 是否可用
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // 請求權限（可擴展以加入寫入功能）
    func requestAuthorization(toRead readTypes: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: readTypes, completion: completion)
    }
    
    // 讀取 HealthKit 資料的樣板方法
    func readStepCount(startDate: Date, endDate: Date) -> Future<[HKQuantitySample], Error> {
        return Future { promise in
            let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
            let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                let quantitySamples = samples as? [HKQuantitySample] ?? []
                promise(.success(quantitySamples))
            }
            self.healthStore.execute(query)
        }
    }
    
    // 預留寫入功能
    func saveStepCount(stepCount: Double, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let quantity = HKQuantity(unit: .count(), doubleValue: stepCount)
        let sample = HKQuantitySample(type: stepType, quantity: quantity, start: date, end: date)
        
        healthStore.save(sample, withCompletion: completion)
    }
    
    // 讀取步數資料
    func readStepCountClosure(startDate: Date, endDate: Date, completion: @escaping (Result<[HKQuantitySample], Error>) -> Void) {
        let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let quantitySamples = samples as? [HKQuantitySample] ?? []
            completion(.success(quantitySamples))
        }
        healthStore.execute(query)
    }
}
