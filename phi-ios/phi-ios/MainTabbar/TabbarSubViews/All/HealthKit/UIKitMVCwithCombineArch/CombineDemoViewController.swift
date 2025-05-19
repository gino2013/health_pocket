//
//  CombineDemoViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/30.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 請求授權
        HealthKitManagerExt.shared.requestAuthorization()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("授權失敗：\(error.localizedDescription)")
                }
            }, receiveValue: { success in
                if success {
                    print("授權成功")
                    self.loadHealthData()
                } else {
                    print("授權失敗或被拒絕")
                }
            })
            .store(in: &cancellables)
    }
    
    private func loadHealthData() {
        // 讀取今日步數
        HealthKitManagerExt.shared.fetchTodayStepCount()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("讀取今日步數失敗：\(error.localizedDescription)")
                }
            }, receiveValue: { steps in
                print("今日步數：\(steps)")
                self.updateStepCountUI(steps)
            })
            .store(in: &cancellables)
        
        // 讀取本週步數
        HealthKitManagerExt.shared.fetchWeekSteps()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("讀取本週步數失敗：\(error.localizedDescription)")
                }
            }, receiveValue: { weekSteps in
                print("本週步數：\(weekSteps)")
                self.updateWeeklyStepsUI(weekSteps)
            })
            .store(in: &cancellables)
    }
    
    private func updateStepCountUI(_ steps: Int) {
        // 更新 UI 顯示今日步數
    }
    
    private func updateWeeklyStepsUI(_ steps: [Date: Int]) {
        // 更新 UI 顯示本週步數
    }
    
    // 持續性更新使用
    /*
    private func setupBindings() {
        // 訂閱 stepCountToday 的變化
        healthKitManagerExt.$stepCountToday
            .receive(on: DispatchQueue.main)
            .sink { [weak self] steps in
                self?.updateStepCountUI(steps)
            }
            .store(in: &cancellables)
        
        // 訂閱 thisWeekSteps 的變化
        healthKitManagerExt.$thisWeekSteps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weekSteps in
                self?.updateWeeklyStepsUI(weekSteps)
            }
            .store(in: &cancellables)
    }
    */
}
