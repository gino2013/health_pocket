//
//  SearchPolicyViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/11/14.
//

import UIKit
import ProgressHUD

class SearchPolicyViewController: BaseViewController {
    
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            //tblView.allowsSelection = false
            tblView.showsVerticalScrollIndicator = false
        }
    }
    //@IBOutlet weak var emptyImageView: UIImageView!
    //@IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var searchInputView: SearchInputView!
    @IBOutlet weak var searchNoticeLabel: UILabel!
    
    private let cellIdentifier = "ListTableViewCell"
    var firstTimeData: [String] = [] // All Data
    var currentData: [String] = []
    var refreshControl = UIRefreshControl()
    var lastIndexPath: IndexPath?
    var selectedItem: String = ""
    var currentKeyWord: String = ""
    private var isFirstTime: Bool = true
    private var isFirstTimeSaveData: Bool = true
    var currentPage = 0
    var isLoading = false // 是否正在載入數據
    var hasNextPage = false
    var searchTrigger: Bool = false
    var rollbackTrigger: Bool = false
    // 定義一個閉包屬性，用來傳遞資料
    var onSaveItem: ((_ item: String) -> ())?       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateUI(fromSrvRsp: [String]) {
        currentData = fromSrvRsp
        
        if currentData.count > 0 {
            self.hiddenNoNeedUI(enableHidden: true)
            self.tblView.reloadData()
            
            /*
            if self.searchTrigger {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            */
        } else {
            self.hiddenNoNeedUI(enableHidden: false)
        }
    }
    
    func updateUI() {
        refreshControl.addTarget(self, action: #selector(refreshCurrentData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)

        searchInputView.textField.delegate = self
        searchInputView.textField.keyboardType = .default
        searchInputView.textField.returnKeyType = .search
        searchInputView.textField.placeholder = "搜尋保單"
        searchInputView.textField.delegate = self
        searchInputView.isShowSearchBtn = false
        
        updateUI(fromSrvRsp: self.firstTimeData)
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        //emptyImageView.isHidden = enableHidden
        //noteLabel.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    @objc func refreshCurrentData() {
        refreshControl.endRefreshing()
        // ???
    }
    
    func rollBackToFirstTimeData() {
        self.rollbackTrigger = true
        self.searchTrigger = false
        self.currentData = self.firstTimeData
        
        if self.currentData.count == 0 {
            self.hiddenNoNeedUI(enableHidden: false)
        } else {
            self.hiddenNoNeedUI(enableHidden: true)
        }
        
        self.tblView.reloadData()
        //let indexPath = IndexPath(row: 0, section: 0)
        //self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func processInpurSearchText(searchStr: String) {
        print("processInpurSearchText \(searchStr)!")
        
        self.currentKeyWord = searchStr
        
        var results: [String] = []
        
        if self.currentKeyWord.isEmpty {
            self.rollBackToFirstTimeData()
            self.searchNoticeLabel.text = "顯示：全部"
        } else {
            self.searchNoticeLabel.text = "顯示：\(currentKeyWord) 結果"
            self.searchTrigger = true
            self.rollbackTrigger = false
            
            // start to search in local data
            results = self.currentData.filter { $0.contains(self.currentKeyWord) }
            if results.count > 0 {
                self.currentData = results
            } else {
                self.currentData = self.firstTimeData
            }
            self.tblView.reloadData()
        }
        
        ProgressHUD.dismiss()  // 隱藏搜尋完成的 HUD
    }
}

extension SearchPolicyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        if indexPath.row < currentData.count {
            listCell.updateCell(itemName: currentData[indexPath.row])
        }
        return listCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < currentData.count {
            // Save current item
            selectedItem = currentData[indexPath.row]
            // 使用閉包傳遞資料
            onSaveItem?(selectedItem)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}

extension SearchPolicyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == searchInputView.textField {
            if let currentText = textField.text, currentText.count >= 64 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 在此處理搜尋行為
        print("執行搜尋：\(textField.text ?? "")")
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        processInpurSearchText(searchStr: textField.text ?? "")
        textField.resignFirstResponder()  // 關閉鍵盤
        return true
    }
}
