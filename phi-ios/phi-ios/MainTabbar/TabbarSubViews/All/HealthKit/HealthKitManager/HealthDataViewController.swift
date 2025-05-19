//
//  HealthDataViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/29.
//

import UIKit

// MARK: - View Controller
class HealthDataViewController: UIViewController {
    private let viewModel = HealthViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshData)
        )
    }()
    
    private var dataPoints: [HealthDataPoint] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        requestPermissions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "健康數據"
        view.backgroundColor = .systemBackground
        
        // 設置導航欄
        navigationItem.rightBarButtonItem = refreshButton
        
        // 設置活動指示器
        activityIndicator.hidesWhenStopped = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        // 設置表格視圖
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onDataUpdate = { [weak self] dataPoints in
            DispatchQueue.main.async {
                self?.dataPoints = dataPoints
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error)
            }
        }
        
        viewModel.onAuthorizationComplete = { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.loadHealthData()
                } else {
                    self?.showError(NSError(domain: "HealthKit",
                                          code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "未獲得授權"]))
                }
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.refreshButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshButton.isEnabled = true
                }
            }
        }
    }
    
    // MARK: - Data Loading
    private func requestPermissions() {
        viewModel.requestHealthKitPermission()
    }
    
    @objc private func refreshData() {
        loadHealthData()
    }
    
    private func loadHealthData() {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        viewModel.fetchHealthData(type: .steps, startDate: startDate, endDate: endDate)
    }
    
    // MARK: - Error Handling
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "錯誤",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView Extensions
extension HealthDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dataPoint = dataPoints[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        let formattedDate = dateFormatter.string(from: dataPoint.date)
        cell.textLabel?.text = "\(formattedDate): \(Int(dataPoint.value)) 步"
        
        return cell
    }
}
