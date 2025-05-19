//
//  BleTestViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/11/11.
//

import UIKit
import CoreBluetooth

class BleTestViewController: UIViewController {
    
    // MARK: - UI 元件
    private let systolicLabel: UILabel = {
        let label = UILabel()
        label.text = "收縮壓: --"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let diastolicLabel: UILabel = {
        let label = UILabel()
        label.text = "舒張壓: --"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let heartRateLabel: UILabel = {
        let label = UILabel()
        label.text = "心跳: --"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("開始掃描", for: .normal)
        return button
    }()
    
    // MARK: - 藍牙服務
    private var bluetoothService: BluetoothService!
    
    // MARK: - 視圖初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        // 在此設定按鈕的目標方法
        scanButton.addTarget(self, action: #selector(startScanning), for: .touchUpInside)
        
        // 初始化藍牙服務
        bluetoothService = BluetoothService()
        
        bluetoothService.isTestingMode = true // 啟用測試模式
        
        // 設定閉包來接收更新的血壓數據
        bluetoothService.onDataReceived = { [weak self] systolic, diastolic, heartRate in
            self?.updateBloodPressureLabels(systolic: systolic, diastolic: diastolic, heartRate: heartRate)
        }
    }
    
    // MARK: - 設置 UI
    private func setupUI() {
        // 將元件添加至視圖
        let stackView = UIStackView(arrangedSubviews: [systolicLabel, diastolicLabel, heartRateLabel, scanButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 設置約束
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - 按鈕操作
    @objc private func startScanning() {
        bluetoothService.startScanning()
        scanButton.setTitle("掃描中...", for: .normal)
    }
    
    // MARK: - 更新標籤
    private func updateBloodPressureLabels(systolic: Int, diastolic: Int, heartRate: Int) {
        systolicLabel.text = "收縮壓: \(systolic)"
        diastolicLabel.text = "舒張壓: \(diastolic)"
        heartRateLabel.text = "心跳: \(heartRate)"
        scanButton.setTitle("開始掃描", for: .normal)
    }
}
