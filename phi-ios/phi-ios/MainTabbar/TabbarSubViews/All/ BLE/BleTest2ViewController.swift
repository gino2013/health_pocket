//
//  BleTest2ViewController.swift
//  BleDemo2024
//
//  Created by Kenneth Wu on 2024/12/6.
//

import UIKit
import ProgressHUD

class BleTest2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let scanButton = UIButton(type: .system)
    private let connectButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    
    private var devices: [String] = [] // 模擬掃描到的設備名稱
    private var selectedDevice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "血壓監測"
        
        setupUI()
        
        // 歷史記錄導航按鈕
        let historyButton = UIBarButtonItem(
            title: "歷史記錄",
            style: .plain,
            target: self,
            action: #selector(openHistory)
        )
        navigationItem.rightBarButtonItem = historyButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        connectButton.isEnabled = false
        devices = []
        tableView.reloadData()
    }
    
    @objc private func openHistory() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .green // 臨時設置醒目背景，用於調試
        
        // 設置狀態標籤
        statusLabel.text = "狀態: 未掃描"
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // 設置掃描按鈕
        scanButton.setTitle("開始掃描", for: .normal)
        scanButton.addTarget(self, action: #selector(startScan), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanButton)
        
        // 設置表格視圖
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 設置連接按鈕
        connectButton.setTitle("連接到選定設備", for: .normal)
        connectButton.isEnabled = false
        connectButton.addTarget(self, action: #selector(connectToDevice), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)
        
        // 設置約束
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scanButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -20),
            
            connectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // 模擬掃描設備
    @objc private func startScan() {
        statusLabel.text = "狀態: 掃描中..."
        devices = ["設備1", "設備2", "設備3"] // 模擬掃描到的設備
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.statusLabel.text = "狀態: 掃描完成"
        }
    }
    
    // 模擬連接設備
    @objc private func connectToDevice() {
        guard let device = selectedDevice else { return }
        
        ProgressHUD.animate("連線中...", .activityIndicator, interaction: false)
        connectButton.isEnabled = false
        
        // 模擬連線過程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            // 模擬連線成功
            let success = Bool.random() // 隨機模擬成功或失敗
            
            if success {
                ProgressHUD.dismiss()
                self.statusLabel.text = "狀態：已連線到 \(device)"
                let measurementVC = MeasurementViewController(deviceName: device)
                self.navigationController?.pushViewController(measurementVC, animated: true)
            } else {
                ProgressHUD.failed("連線失敗！", interaction: false, delay: 0.75)
            }
            
            self.connectButton.isEnabled = true
        }
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        cell.textLabel?.text = devices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDevice = devices[indexPath.row]
        connectButton.isEnabled = true
    }
}
