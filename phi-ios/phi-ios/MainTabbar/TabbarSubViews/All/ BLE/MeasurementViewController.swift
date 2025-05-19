//
//  MeasurementViewController.swift
//  BleDemo2024
//
//  Created by Kenneth Wu on 2024/12/6.
//

import UIKit

class MeasurementViewController: UIViewController {
    // MARK: - 屬性
    private let deviceName: String
    private let systolicLabel = UILabel()
    private let diastolicLabel = UILabel()
    private let heartRateLabel = UILabel()
    private let disconnectButton = UIButton(type: .system)

    // 模擬數據或實時模式的標誌
    var isSimulationMode: Bool = true
    var onDataReceived: ((Int, Int, Int) -> Void)?

    // MARK: - 初始化
    init(deviceName: String) {
        self.deviceName = deviceName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 視圖生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "測量頁 - \(deviceName)"

        setupUI()
        startMeasurement()
    }

    // MARK: - UI 設置
    private func setupUI() {
        // 設置收縮壓標籤
        systolicLabel.text = "收縮壓: --"
        systolicLabel.font = UIFont.boldSystemFont(ofSize: 20)
        systolicLabel.textAlignment = .center

        // 設置舒張壓標籤
        diastolicLabel.text = "舒張壓: --"
        diastolicLabel.font = UIFont.boldSystemFont(ofSize: 20)
        diastolicLabel.textAlignment = .center

        // 設置心跳標籤
        heartRateLabel.text = "心跳: --"
        heartRateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        heartRateLabel.textAlignment = .center

        // 設置斷開連接按鈕
        disconnectButton.setTitle("斷開連接", for: .normal)
        disconnectButton.addTarget(self, action: #selector(disconnect), for: .touchUpInside)

        // 將所有元件放入堆疊視圖
        let stackView = UIStackView(arrangedSubviews: [systolicLabel, diastolicLabel, heartRateLabel, disconnectButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // 設置約束
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - 開始測量
    private func startMeasurement() {
        if isSimulationMode {
            // 模擬模式下回傳假數據
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.updateMeasurement(systolic: 120, diastolic: 80, heartRate: 70)
            }
        } else {
            // 實時模式下等待數據
            onDataReceived = { [weak self] systolic, diastolic, heartRate in
                self?.updateMeasurement(systolic: systolic, diastolic: diastolic, heartRate: heartRate)
            }
        }
    }

    // MARK: - 更新測量結果
    private func updateMeasurement(systolic: Int, diastolic: Int, heartRate: Int) {
        systolicLabel.text = "收縮壓: \(systolic)"
        diastolicLabel.text = "舒張壓: \(diastolic)"
        heartRateLabel.text = "心跳: \(heartRate)"
    }

    // MARK: - 斷開連接
    @objc private func disconnect() {
        // 返回上一頁
        navigationController?.popViewController(animated: true)
    }
}
