//
//  HealthKitManager.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/29.
//

import HealthKit
import UIKit

// MARK: - Models
struct HealthDataPoint {
    let date: Date
    let value: Double
}

enum HealthDataType {
    case steps
    case heartRate
    case calories
    case distance
    
    var quantityType: HKQuantityType {
        switch self {
        case .steps:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)!
        case .heartRate:
            return HKQuantityType.quantityType(forIdentifier: .heartRate)!
        case .calories:
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        case .distance:
            return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        }
    }
    
    var unit: HKUnit {
        switch self {
        case .steps:
            return .count()
        case .heartRate:
            return .count().unitDivided(by: .minute())
        case .calories:
            return .kilocalorie()
        case .distance:
            return .meter()
        }
    }
    
    var displayName: String {
        switch self {
        case .steps:
            return "步數"
        case .heartRate:
            return "心率"
        case .calories:
            return "卡路里"
        case .distance:
            return "距離"
        }
    }
}

// MARK: - HealthKit Manager
class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    private let readTypes: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ]
    
    // 加入寫入權限
    private let writeTypes: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ]
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available"]))
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success, error)
        }
    }
    
    func fetchHealthData<T: HKQuantityType>(
        for type: T,
        unit: HKUnit,
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<[HealthDataPoint], Error>) -> Void
    ) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = results else {
                completion(.failure(NSError(domain: "HealthKit", code: -1,
                                         userInfo: [NSLocalizedDescriptionKey: "No data available"])))
                return
            }
            
            var dataPoints: [HealthDataPoint] = []
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let value = quantity.doubleValue(for: unit)
                    let dataPoint = HealthDataPoint(date: statistics.startDate, value: value)
                    dataPoints.append(dataPoint)
                }
            }
            
            completion(.success(dataPoints))
        }
        
        healthStore.execute(query)
    }
    
    // 新增寫入健康資料的方法
    func saveHealthData(type: HealthDataType, value: Double, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let quantityType = type.quantityType
        let unit = type.unit
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        
        let sample = HKQuantitySample(
            type: quantityType,
            quantity: quantity,
            start: date,
            end: date
        )
        
        healthStore.save(sample) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // 批量寫入健康資料的方法
    func saveBulkHealthData(type: HealthDataType, dataPoints: [HealthDataPoint], completion: @escaping (Bool, Error?) -> Void) {
        let quantityType = type.quantityType
        let unit = type.unit
        
        let samples = dataPoints.map { dataPoint in
            let quantity = HKQuantity(unit: unit, doubleValue: dataPoint.value)
            return HKQuantitySample(
                type: quantityType,
                quantity: quantity,
                start: dataPoint.date,
                end: dataPoint.date
            )
        }
        
        healthStore.save(samples) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
