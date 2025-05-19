//
//  PersonMessageVController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/24.
//

import UIKit
import ProgressHUD

class PersonMessageVController: BaseViewController {
    
    @IBOutlet weak var hTableView: UITableView! {
        didSet {
            hTableView.dataSource = self
            hTableView.delegate = self
            hTableView.tableFooterView = UIView()
            hTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            hTableView.separatorStyle = .none
            //tblView.allowsSelection = false
            hTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    private let normalMsgCellIdentifier = "NormalMessageTableViewCell"
    private let msgCellIdentifier = "MessageTableViewCell"
    var data = systemMessageSampleData()
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var currentPage = 0
    var hasNextPage = false
    var prePage: PreviousPage = .medicalHistory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // getMessageList(medicalType: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data.removeAll()
        
        if data.count > 0 {
            hiddenNoNeedUI(enableHidden: true)
            hTableView.reloadData()
        } else {
            hiddenNoNeedUI(enableHidden: false)
        }
    }
    
    func updateUI() {
        hTableView.register(nibWithCellClass: NormalMessageTableViewCell.self)
        hTableView.register(nibWithCellClass: MessageTableViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshMsgInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        hTableView.addSubview(refreshControl)
    }
    
    @objc func refreshMsgInfos() {
        refreshControl.endRefreshing()
        
        currentPage = 0
        // getMessageList(medicalType: "")
    }

    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        hTableView.isHidden = !enableHidden
    }
}

extension PersonMessageVController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = data[indexPath.row].cellType
        
        switch cellType {
        case .noSubMessageType:
            guard let normalMsgCell = tableView.dequeueReusableCell(withIdentifier: normalMsgCellIdentifier, for: indexPath) as? NormalMessageTableViewCell else {
                fatalError("Issue dequeuing \(normalMsgCellIdentifier)")
            }
            
            if indexPath.row < data.count {
                normalMsgCell.configureCell(viewModel: data[indexPath.row])
            }
            return normalMsgCell
        
        case .containSubMessageType:
            guard let msgItemCell = tableView.dequeueReusableCell(withIdentifier: msgCellIdentifier, for: indexPath) as? MessageTableViewCell else {
                fatalError("Issue dequeuing \(msgCellIdentifier)")
            }
            
            if indexPath.row < data.count {
                msgItemCell.configureCell(viewModel: data[indexPath.row])
            }
            return msgItemCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = data[indexPath.row].cellType
        
        switch cellType {
        case .noSubMessageType:
            return 78
        case .containSubMessageType:
            return 100
        }
    }
}
