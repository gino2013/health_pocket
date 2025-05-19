//
//  BluetoothHelper.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/12/9.
//

import CoreBluetooth

class BluetoothHelper: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // MARK: - 屬性
    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var targetCharacteristic: CBCharacteristic?
    
    var isTestingMode = true // 是否啟用模擬模式
    var onDataReceived: ((Int, Int, Int) -> Void)? // 回傳數據的閉包
    var onStateChange: ((String) -> Void)? // 藍牙狀態改變的閉包

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - 模擬數據
    private func simulateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.onDataReceived?(120, 80, 70) // 模擬數據：收縮壓 120、舒張壓 80、心跳 70
        }
    }

    // MARK: - 藍牙掃描
    func startScanning() {
        if isTestingMode {
            simulateData()
        } else {
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "1810")], options: nil)
        }
    }

    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateDescription: String
        switch central.state {
        case .poweredOn:
            stateDescription = "藍牙已開啟，開始掃描"
            startScanning()
        case .poweredOff:
            stateDescription = "藍牙未開啟，請打開藍牙"
        case .unsupported:
            stateDescription = "裝置不支持藍牙"
        default:
            stateDescription = "藍牙狀態未知"
        }
        onStateChange?(stateDescription)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        targetPeripheral = peripheral
        targetPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([CBUUID(string: "1810")])
    }

    // MARK: - CBPeripheralDelegate
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
                targetCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        parseBloodPressureData(data)
    }

    // MARK: - 數據解析
    private func parseBloodPressureData(_ data: Data) {
        let systolic = Int(data[0])
        let diastolic = Int(data[1])
        let heartRate = Int(data[2])
        onDataReceived?(systolic, diastolic, heartRate)
    }
}
