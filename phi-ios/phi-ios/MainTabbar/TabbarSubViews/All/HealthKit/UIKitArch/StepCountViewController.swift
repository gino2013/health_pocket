//
//  StepCountViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/25.
//

import UIKit

class StepCountViewController: UIViewController {
    private let viewModel = HealthInfoViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestAuthorizationAndLoadData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Step Count"
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StepCountCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    private func requestAuthorizationAndLoadData() {
        viewModel.requestHealthKitAuthorization { [weak self] success, error in
            guard let self = self else { return }
            if success {
                let startDate = Calendar.current.startOfDay(for: Date())
                let endDate = Date()
                self.viewModel.fetchStepCount(startDate: startDate, endDate: endDate) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error?.localizedDescription ?? "Authorization failed.")
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StepCountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stepCountData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCountCell", for: indexPath)
        let sample = viewModel.stepCountData[indexPath.row]
        cell.textLabel?.text = "Steps: \(sample.quantity.doubleValue(for: .count()))"
        return cell
    }
}

