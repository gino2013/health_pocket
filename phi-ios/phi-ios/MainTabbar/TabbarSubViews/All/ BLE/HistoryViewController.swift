//
//  HistoryViewController.swift
//  BleDemo2024
//
//  Created by Kenneth Wu on 2024/12/6.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private var records: [NSManagedObject] = []
    private var filteredRecords: [NSManagedObject] = []
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let filterButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "血壓歷史記錄"
        
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        // 設置開始日期選擇器
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .compact
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startDatePicker)
        
        // 設置結束日期選擇器
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .compact
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endDatePicker)
        
        // 設置篩選按鈕
        filterButton.setTitle("篩選", for: .normal)
        filterButton.addTarget(self, action: #selector(filterDataByDateRange), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        
        // 設置表格視圖
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 設置約束
        NSLayoutConstraint.activate([
            startDatePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.topAnchor),
            endDatePicker.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 20),
            
            filterButton.centerYAnchor.constraint(equalTo: startDatePicker.centerYAnchor),
            filterButton.leadingAnchor.constraint(equalTo: endDatePicker.trailingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BloodPressure")
        
        /*
        systolic（Int16）：收縮壓。
        diastolic（Int16）：舒張壓。
        timestamp（Date）：測量時間。
        */
        do {
            records = try context.fetch(fetchRequest)
            filteredRecords = records
            tableView.reloadData()
        } catch {
            print("數據獲取失敗：\(error.localizedDescription)")
        }
    }
    
    @objc private func filterDataByDateRange() {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        let calendar = Calendar.current
        
        filteredRecords = records.filter { record in
            if let timestamp = record.value(forKey: "timestamp") as? Date {
                return timestamp >= calendar.startOfDay(for: startDate) &&
                timestamp <= calendar.startOfDay(for: endDate).addingTimeInterval(86399) // 一天的秒數
            }
            return false
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let record = filteredRecords[indexPath.row]
        
        let systolic = record.value(forKey: "systolic") as? Int16 ?? 0
        let diastolic = record.value(forKey: "diastolic") as? Int16 ?? 0
        let timestamp = record.value(forKey: "timestamp") as? Date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: timestamp)
        
        cell.textLabel?.text = "\(dateString): \(systolic)/\(diastolic)"
        return cell
    }
}
