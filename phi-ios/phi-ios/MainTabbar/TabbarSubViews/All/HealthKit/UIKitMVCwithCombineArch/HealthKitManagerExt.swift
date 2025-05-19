//
//  HealthKitManagerExt.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/30.
//

import HealthKit
import Combine

class HealthKitManagerExt {
    static let shared = HealthKitManagerExt()
    private let healthStore = HKHealthStore()
    
    private init() {} // 確保單例模式
    
    // 健康數據類型
    private let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    // MARK: - 授權相關
    func requestAuthorization() -> Future<Bool, Error> {
        return Future { promise in
            guard HKHealthStore.isHealthDataAvailable() else {
                print("HealthKit 不可用")
                promise(.success(false))
                return
            }
            
            let typesToRead: Set<HKObjectType> = [self.stepCountType]
            
            self.healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("授權失敗: \(error.localizedDescription)")
                        promise(.failure(error))
                        return
                    }
                    promise(.success(success))
                }
            }
        }
    }
    
    // MARK: - 讀取今日步數（返回一次性 Future）
    func fetchTodayStepCount() -> Future<Int, Error> {
        return Future { promise in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            let predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: now,
                options: .strictStartDate
            )
            
            let query = HKStatisticsQuery(
                quantityType: self.stepCountType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    guard let result = result,
                          let sum = result.sumQuantity() else {
                        promise(.failure(NSError(domain: "HealthKit",
                                                 code: 0,
                                                 userInfo: [NSLocalizedDescriptionKey: "No data available"])))
                        return
                    }
                    
                    let steps = Int(sum.doubleValue(for: .count()))
                    promise(.success(steps))
                }
            }
            
            self.healthStore.execute(query)
        }
    }
    
    // MARK: - 讀取本週步數（返回一次性 Future）
    func fetchWeekSteps() -> Future<[Date: Int], Error> {
        return Future { promise in
            let calendar = Calendar.current
            let now = Date()
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            
            let predicate = HKQuery.predicateForSamples(
                withStart: startOfWeek,
                end: now,
                options: .strictStartDate
            )
            
            let query = HKStatisticsCollectionQuery(
                quantityType: self.stepCountType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: startOfWeek,
                intervalComponents: DateComponents(day: 1)
            )
            
            query.initialResultsHandler = { _, results, error in
                DispatchQueue.main.async {
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    var steps: [Date: Int] = [:]
                    
                    results?.enumerateStatistics(from: startOfWeek, to: now) { statistics, _ in
                        if let quantity = statistics.sumQuantity() {
                            let date = statistics.startDate
                            let value = Int(quantity.doubleValue(for: .count()))
                            steps[date] = value
                        }
                    }
                    
                    promise(.success(steps))
                }
            }
            
            self.healthStore.execute(query)
        }
    }
}
