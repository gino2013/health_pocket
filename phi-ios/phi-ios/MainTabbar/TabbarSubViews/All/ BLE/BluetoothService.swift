//
//  BluetoothService.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/11/8.
//

import CoreBluetooth

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - 屬性
    private var centralManager: CBCentralManager!
    private var bloodPressureMonitor: CBPeripheral?
    
    // 將這個屬性設定為 true 來模擬數據
    var isTestingMode = true
    // 將數據回傳給主視圖控制器的閉包
    var onDataReceived: ((Int, Int, Int) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func simulateData() {
        // 模擬延遲後回傳假數據
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.onDataReceived?(120, 80, 70) // 模擬數據：收縮壓 120、舒張壓 80、心跳 70
        }
    }
    
    // 開始掃描
    func startScanning() {
        if isTestingMode {
            simulateData()
        } else {
            // 正常藍牙掃描邏輯
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "1810")], options: nil)
        }
    }
    
    // CBCentralManagerDelegate 方法
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        bloodPressureMonitor = peripheral
        bloodPressureMonitor?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([CBUUID(string: "1810")])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        parseBloodPressureData(data)
    }
    
    private func parseBloodPressureData(_ data: Data) {
        // 假設的數據解析方式
        let systolic = Int(data[0])
        let diastolic = Int(data[1])
        let heartRate = Int(data[2])
        
        // 調用閉包，傳回解析後的數據
        onDataReceived?(systolic, diastolic, heartRate)
    }
}
