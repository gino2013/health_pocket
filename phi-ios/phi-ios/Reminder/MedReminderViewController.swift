//
//  MedReminderViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/8.
//

import UIKit
import KeychainSwift
import ProgressHUD
import PanModal

class MedReminderViewController: BaseViewController {
    
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var stepUIView: UIView!
    @IBOutlet weak var titleView1: UIView!
    @IBOutlet weak var reminderListView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            //tblView.allowsSelection = false
            //tblView.rowHeight = UITableView.automaticDimension
            //tblView.estimatedRowHeight = 2
            tblView.showsVerticalScrollIndicator = false
            tblView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var titleView2: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    private let cellIdentifier = "AddReminderTViewCell"
    
    var allData: [AddReminderCellViewModel] = []
    var currentData: [AddReminderCellViewModel] = []
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    // var groupedPrescriptionInfos: [String: [AddReminderCellViewModel]] = [:]
    var currentSelectItems: [AddReminderCellViewModel] = []
    private var medicationReminderInfos: [MedicationReminder] = [
        // for test
        /*
        MedicationReminder(
            medicationNames: ["停敏膜衣锭", "止痛药"],
            frequencyType: .daily,
            times: ["08:30", "12:30", "18:30"],
            period: "2023/07/16 - 2023/08/16"
        ),
        MedicationReminder(
            medicationNames: ["喉嚨痛藥", "止痛药"],
            frequencyType: .interval(days: 3),
            times: ["08:30", "18:30"],
            period: "2023/07/15 - 2023/08/15"
        )
        */
    ]
    private var isFirstTime: Bool = true
    
    func updateTableViewHeight() {
        DispatchQueue.main.async {
            self.tblView.layoutIfNeeded()
            let contentHeight = self.tblView.contentSize.height
            self.tblViewHeightConstraint.constant = contentHeight
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        createRightBarButtonViaImage(imageName: "info_black")
        updateUI()
        
        for i in 0 ..< SharingManager.sharedInstance.currAutoImportPrescriptionInfos.count {
            let srcItem: PrescriptionInfo = SharingManager.sharedInstance.currAutoImportPrescriptionInfos[i]
            let item: AddReminderCellViewModel = AddReminderCellViewModel(cellId: i, cellInfo: srcItem, addBottomLine: false, selectStatus: .noSelect)
            
            currentData.append(item)
        }
        
        allData = currentData.map { $0 }
        
        // ???
        // groupedPrescriptionInfos = groupByPrescriptionCode(prescriptionInfos: currentData)
        
        updateUI(fromSrvRsp: currentData)
    }
    
    deinit {
        // NotificationCenter.default.removeObserver(self)
    }
    
    @objc override func rightBarButtonTapped() {
        //let isSuccess = true
        let successMessage = "此功能尚未開放，敬請期待"
        //let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: "提醒", message: successMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            if SharingManager.sharedInstance.currentSetReminderMode == .auto {
                showNotice()
            }
            isFirstTime = false
        }
        
        if SharingManager.sharedInstance.currentSetReminderMode == .manual {
            stepUIView.isHidden = false
        } else {
            stepUIView.isHidden = true
        }
    }
    
    func updateReminderGroupUI() {
        titleView1.isHidden = false
        reminderListView.isHidden = false
        
        for i in 0 ..< self.medicationReminderInfos.count {
            let medicationReminderInfo: MedicationReminder = self.medicationReminderInfos[i]
            
            if i == self.medicationReminderInfos.count - 1 {
                self.setItemView(medicationReminderInfo: medicationReminderInfo, addBottomLine: false, itemIndex: i)
            } else {
                self.setItemView(medicationReminderInfo: medicationReminderInfo, addBottomLine: true, itemIndex: i)
            }
        }
    }
    
    func updateUI(fromSrvRsp: [AddReminderCellViewModel]) {
        
        if self.medicationReminderInfos.count > 0 {
            updateReminderGroupUI()
        } else {
            titleView1.isHidden = true
            reminderListView.isHidden = true
        }
        
        //parentScrollView.setContentOffset(CGPoint.zero, animated: false)
        //parentScrollView.layoutIfNeeded()
        
        if fromSrvRsp.count > 0 {
            hiddenNoNeedUI(enableHidden: true)
            tblView.reloadData()
            tblView.layoutIfNeeded()
        } else {
            if self.medicationReminderInfos.count == 0 {
                hiddenNoNeedUI(enableHidden: false)
            }
        }
    }
    
    func showNotice() {
        let alertViewController = UINib.load(nibName: "FixedVerifyResultAlertVC") as! FixedVerifyResultAlertVC
        //alertViewController.delegate = self
        alertViewController.alertType = .importedReminder
        alertViewController.alertLabel.text = "藥品已匯入用藥提醒"
        alertViewController.alertBtn.setTitle("我知道了", for: .normal)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func customBarButtonTapped() {
        //let isSuccess = true
        let successMessage = "此功能尚未開放，敬請期待"
        //let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: "提醒"/*: "錯誤"*/,
                                      message: successMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        titleView1.isHidden = true
        reminderListView.isHidden = true
        
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        parentScrollView.delegate = self
        
        tblView.register(nibWithCellClass: AddReminderTViewCell.self)
        
        refreshControl.addTarget(self, action: #selector(refreshCurrentData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        reminderListView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //buttonContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        itemListView.distribution = .equalSpacing
        itemListView.alignment = .fill
        itemListView.spacing = 10
        itemListView.translatesAutoresizingMaskIntoConstraints = false
        
        resetButtonsUI()
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    @objc func refreshCurrentData() {
        refreshControl.endRefreshing()
    }
    
    @objc override func popPresentedViewController() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        if SharingManager.sharedInstance.currentSetReminderMode == .auto {
            alertViewController.messageLabel.text = "是否放棄設定並返回「領藥結果」?"
        } else {
            alertViewController.messageLabel.text = "是否放棄設定並返回「新增藥品」?"
        }
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .firstAuthorization
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func firstButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EditMedicine", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditMedicineViewController") as! EditMedicineViewController
        vc.currentSelectItems = self.currentSelectItems
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func secondButtonAction(_ sender: UIButton) {
        // Check If setting reminder frequency and time
        if UserDefaults.standard.loadReminderTimeSetting() == nil {
            let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WorkRestTimeSettingVC") as! WorkRestTimeSettingVC
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "MedFrequency", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedFreqSettingViewController") as! MedFreqSettingViewController
            
            vc.currentSelectItems = self.currentSelectItems
            if self.currentSelectItems.count > 0 {
                vc.usagetime = self.currentSelectItems[0].cellInfo.frequencyTimes
                
                // 其他時段
                /*
                if self.currentSelectItems[0].cellInfo.frequencyTimes == -1 {
                    vc.usagetime = 1
                }
                */
            }
            vc.takingTime = self.currentSelectItems[0].cellInfo.takingTime
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickFinishButton(_ sender: UIButton) {
        requestCreateReminderSettings()
    }
    
    func groupByPrescriptionCode(prescriptionInfos: [AddReminderCellViewModel]) -> [String: [AddReminderCellViewModel]] {
        var groupedDictionary = [String: [AddReminderCellViewModel]]()
        
        for info in prescriptionInfos {
            if groupedDictionary[info.cellInfo.prescriptionCode] == nil {
                groupedDictionary[info.cellInfo.prescriptionCode] = [info]
            } else {
                groupedDictionary[info.cellInfo.prescriptionCode]?.append(info)
            }
        }
        
        return groupedDictionary
    }
    
    func findItems(by prescriptionCode: String, from prescriptionInfos: [AddReminderCellViewModel]) -> [AddReminderCellViewModel] {
        return prescriptionInfos.filter { $0.cellInfo.prescriptionCode == prescriptionCode }
    }
    
    func countItems(by prescriptionCode: String, from prescriptionInfos: [AddReminderCellViewModel]) -> Int {
        return prescriptionInfos.filter { $0.cellInfo.prescriptionCode == prescriptionCode }.count
    }
    
    func findMedicineGroup(prescriptionCode: String) {
        currentSelectItems.removeAll()
        
        for i in 0 ..< currentData.count {
            if prescriptionCode == currentData[i].cellInfo.prescriptionCode {
                currentData[i].selectStatus = .selected
                currentSelectItems.append(currentData[i])
            } else {
                currentData[i].selectStatus = .noSelect
            }
        }
        
        for i in 0 ..< currentData.count {
            if currentData[i].selectStatus == .noSelect {
                if countItems(by: currentData[i].cellInfo.prescriptionCode, from: currentData) > 1 {
                    currentData[i].selectStatus = .disable
                }
            }
        }
        
        updateButtonsUI()
    }
    
    func resetButtonsUI() {
        firstButton.isEnabled = false
        firstButton.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
        firstButton.layer.borderColor = UIColor(hex: "#B5BABC", alpha: 1)!.cgColor
        firstButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        firstButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
        firstButton.layer.borderWidth = 1.0
        
        secondButton.isEnabled = false
        secondButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        secondButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        secondButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        secondButton.setTitleColor(UIColor.white, for: .normal)
        secondButton.layer.borderWidth = 1.0
        secondButton.setTitle("設定提醒", for: .normal)
    }
    
    func updateButtonsUI() {
        if currentSelectItems.count >= 1 {
            if currentSelectItems.count == 1 {
                firstButton.isEnabled = true
                firstButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            } else {
                firstButton.isEnabled = false
                firstButton.layer.borderColor = UIColor(hex: "#B5BABC", alpha: 1)!.cgColor
            }
            
            secondButton.isEnabled = true
            secondButton.setTitle("設定提醒(\(currentSelectItems.count))", for: .normal)
            secondButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
            secondButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        } else {
            resetButtonsUI()
        }
    }
}

extension MedReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return countNonReminderSetDoneCells(cells: currentData)
        
        if self.medicationReminderInfos.count > 0 {
            return currentData.count
        } else {
            return allData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let addReminderTViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddReminderTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        if indexPath.row < currentData.count {
            addReminderTViewCell.configureCell(viewModel: currentData[indexPath.row])
        }
        
        return addReminderTViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Optional: deselect the cell after highlighting
        // tableView.deselectRow(at: indexPath, animated: true)
        
        if currentData[indexPath.row].selectStatus == .disable {
            return
        }
        
        if currentData[indexPath.row].selectStatus == .noSelect {
            currentData[indexPath.row].selectStatus = .selected
            
            findMedicineGroup(prescriptionCode: currentData[indexPath.row].cellInfo.prescriptionCode)
        } else {
            currentData.forEach{
                $0.selectStatus = .noSelect
            }
            
            resetButtonsUI()
        }
        
        tableView.beginUpdates()
        //if currentIndexPath != nil {
        //    tableView.reloadRows(at: [currentIndexPath!, indexPath], with: .automatic)
        //} else {
        //    tableView.reloadRows(at: [indexPath], with: .automatic)
        //}
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
}

extension MedReminderViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        MedicationReminderManager.shared.deleteAllReminders()
        
        if SharingManager.sharedInstance.currentSetReminderMode == .auto {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }   
    }
}

extension MedReminderViewController: MedFreqSettingViewControllerDelegate {
    func countNonReminderSetDoneCells(cells: [AddReminderCellViewModel]) -> Int {
        return cells.filter { cellInfo in
            switch cellInfo.selectStatus {
            case .reminderSetDone:
                return false
            default:
                return true
            }
        }.count
    }
    
    // 排序，把reminderSetDone排到最後。
    func sortCellInfos(_ cellInfos: inout [AddReminderCellViewModel]) {
        cellInfos.sort { (cellInfo1, cellInfo2) -> Bool in
            switch (cellInfo1.selectStatus, cellInfo2.selectStatus) {
            case (.reminderSetDone, _):
                return false
            case (_, .reminderSetDone):
                return true
            default:
                return true
            }
        }
    }
    
    func updateCellSelectStatus(status: AddReminderTViewCellSelectStatus) {
        currentData.forEach{
            if $0.selectStatus == .selected {
                $0.selectStatus = status
            }
        }
        sortCellInfos(&currentData)
    }
    
    func removeAlreadySetCell() {
        // 移除所有的 selected
        currentData.removeAll { $0.selectStatus == .selected }
    }
    
    func reloadDataAndUpdateUI() {
        // Note: 使用一個array做法容易導致 memory leak crash, 改用2個array作法
        // updateCellSelectStatus(status: .reminderSetDone)
        
        // clean stackView items
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        if currentData.count > 0 {
            titleView2.isHidden = false
            secondView.isHidden = false
            
            // change button
            firstButton.isHidden = false
            secondButton.isHidden = false
            finishButton.isHidden = true
        } else {
            // ready to finish
            titleView2.isHidden = true
            secondView.isHidden = true
            
            // change button
            firstButton.isHidden = true
            secondButton.isHidden = true
            finishButton.isHidden = false
        }
        
        self.medicationReminderInfos = MedicationReminderManager.shared.getAllReminders()
        updateUI(fromSrvRsp: currentData)
        resetButtonsUI()
        currentSelectItems.removeAll()
    }
    
    func popPanModalAlert() {
        // show PanModalAlert
        presentPanModal(TransientAlertViewController(alertTitle: "已設定成功！"))
        removeAlreadySetCell()
        currentData.forEach{
            $0.selectStatus = .noSelect
        }
        reloadDataAndUpdateUI()
    }
}

extension MedReminderViewController: WorkRestTimeSettingVCDelegate {
    func presentNextSettingView() {
        let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReminderTimeSettingVC") as! ReminderTimeSettingVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension MedReminderViewController: SettingCompleteVCDelegate {
    func presentFrequencySettingView() {
        let storyboard = UIStoryboard(name: "MedFrequency", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedFreqSettingViewController") as! MedFreqSettingViewController
        
        if self.currentSelectItems.count > 0 {
            vc.usagetime = self.currentSelectItems[0].cellInfo.frequencyTimes
        }
        vc.takingTime = self.currentSelectItems[0].cellInfo.takingTime
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension MedReminderViewController: ReminderTimeSettingVCDelegate {
    func presentWorkRestTimeSettingView() {
        let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WorkRestTimeSettingVC") as! WorkRestTimeSettingVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentSettingFinishView() {
        let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingCompleteVC") as! SettingCompleteVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension MedReminderViewController {
    func setItemView(medicationReminderInfo: MedicationReminder, addBottomLine: Bool, itemIndex: Int) {
        let view = ReminderNote()
        
        view.titleText = "提醒\(itemIndex+1)"
        view.medicineNameText = medicationReminderInfo.combinedMedicationNames()
        view.useDaysText = medicationReminderInfo.frequencyDescription()
        view.takeTimeText = medicationReminderInfo.combinedTimes()
        view.dateIntervalText = medicationReminderInfo.getPeriod()
        view.addviewShadow = true
        view.currentIndex = itemIndex
        view.delegate = self
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 190.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: ReminderNote) {
        if let first = self.itemListView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension MedReminderViewController: ReminderNoteViewDelegate {
    func editReminder(itemIndex: Int) {
        // 處理編輯提醒的邏輯
        let storyboard = UIStoryboard(name: "MedFrequency", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedFreqSettingViewController") as! MedFreqSettingViewController
        
        if itemIndex < self.medicationReminderInfos.count {
            let item: MedicationReminder = self.medicationReminderInfos[itemIndex]
            
            vc.currentReminder = item
        }
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func removeReminder(itemIndex: Int) {
        // 刪除提醒並更新UI
        if itemIndex < self.medicationReminderInfos.count {
            let item: MedicationReminder = self.medicationReminderInfos[itemIndex]
            var medicationIdsToRestore: [Int] = []
            
            if let deletedMedicationIds = MedicationReminderManager.shared.deleteReminder(byID: item.reminderId) {
                medicationIdsToRestore = deletedMedicationIds
                
                // 恢復藥品清單
                let medicationsToRestore = self.allData.filter { medicationIdsToRestore.contains($0.cellId)
                }
                self.currentData.append(contentsOf: medicationsToRestore)
                
                // 重設藥品選取狀態
                currentData.forEach{
                    $0.selectStatus = .noSelect
                }
                
                // reload UI
                // show PanModalAlert
                presentPanModal(TransientAlertViewController(alertTitle: "解除成功！"))
                reloadDataAndUpdateUI()
            }
        }
    }
    
    func editMedication(itemIndex: Int) {
        // 處理編輯藥品的邏輯
        if itemIndex < self.medicationReminderInfos.count {
            let item: MedicationReminder = self.medicationReminderInfos[itemIndex]
            var medicationIdsToRestore: [Int] = []
            
            if let medicationIds = MedicationReminderManager.shared.getMedicationIds(byID: item.reminderId) {
                medicationIdsToRestore = medicationIds
                
                // 恢復藥品清單
                let medicationsToRestore = self.allData.filter { medicationIdsToRestore.contains($0.cellId)
                }

                if medicationsToRestore.count == 1 {
                    if SharingManager.sharedInstance.currentSetReminderMode == .manual {
                        let storyboard = UIStoryboard(name: "EditMedicine", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EditMultiMedicineViewController") as! EditMultiMedicineViewController
                        vc.currentMedicineInfo = item.medicineInfos
                        vc.currentUsagetimeDesc = medicationsToRestore[0].cellInfo.usagetimeDesc
                        vc.delegate = self
                        vc.currentReminderItemIndex = item.reminderId
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let storyboard = UIStoryboard(name: "EditMedicine", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EditMedicineViewController") as! EditMedicineViewController
                        //vc.currentSelectItems = medicationsToRestore
                        vc.currentMedicineInfo = item.medicineInfos
                        vc.currentUsagetimeDesc = medicationsToRestore[0].cellInfo.usagetimeDesc
                        vc.delegate = self
                        vc.editReminderMode = true
                        vc.currentReminderItemIndex = item.reminderId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    // Change to multi-EditMedicineViewController
                    let storyboard = UIStoryboard(name: "EditMedicine", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EditMultiMedicineViewController") as! EditMultiMedicineViewController
                    vc.currentMedicineInfo = item.medicineInfos
                    vc.currentUsagetimeDesc = medicationsToRestore[0].cellInfo.usagetimeDesc
                    vc.delegate = self
                    vc.currentReminderItemIndex = item.reminderId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func clickMoreBtn(itemIndex: Int) {
        print("reminder index = \(itemIndex)!")
        
        let actionSheet = UIAlertController()
        
        let editReminderAction = UIAlertAction(title: "編輯提醒", style: .default) { _ in
            self.editReminder(itemIndex: itemIndex)
        }
        
        let removeReminderAction = UIAlertAction(title: "解除提醒", style: .default) { _ in
            self.removeReminder(itemIndex: itemIndex)
        }
        
        let editMedicationAction = UIAlertAction(title: "編輯藥品", style: .default) { _ in
            self.editMedication(itemIndex: itemIndex)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(editReminderAction)
        actionSheet.addAction(removeReminderAction)
        actionSheet.addAction(editMedicationAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension MedReminderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension MedReminderViewController {
    func requestCreateReminderSettings() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let reqInfo: CreateReminderSettingModel = CreateReminderSettingModel(reminders: MedicationReminderManager.shared.createAPIRequestModel())
        SDKManager.sdk.createReminderSettings(reqInfo) {
            (responseModel: PhiResponseModel<ReminderSettingIdRspModel>) in
            
            if responseModel.success {
                guard let reminderSettingIds = responseModel.data else {
                    return
                }
                
                print("reminderSettingIds=\(reminderSettingIds)")
                
                MedicationReminderManager.shared.deleteAllReminders()
                SharingManager.sharedInstance.reminderPushToMedicationManagementPage = true
                
                DispatchQueue.main.async {
                    _ = self.navigationController?.popToRootViewControllerDisableAnimate({
                        if let mostTopViewController = SDKUtils.mostTopViewController,
                           let tabBarController = (mostTopViewController as? MainTabBarController) ?? mostTopViewController.presentingViewController as? MainTabBarController {
                            tabBarController.selectedIndex = 1
                        }
                    })
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.requestCreateReminderSettings()
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib(nibName: "VerifyResultAlertVC", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
            ProgressHUD.dismiss()
        }
    }
}

extension MedReminderViewController: EditMultiMedicineViewControllerDelegate {
    func editMultiClickSaveBtn(medicineAlias: [String], reminderIndex: String) {
        // show PanModal Alert
        presentPanModal(TransientAlertViewController(alertTitle: "已編輯成功！"))
        MedicationReminderManager.shared.modifyMedicineInfoAlias(reminderId: reminderIndex, medicineAlias: medicineAlias)
    }
    
    func editMultiClickSaveBtn(medicineInfoUpdates: [(dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String)], reminderIndex: String) {
        // show PanModal Alert
        presentPanModal(TransientAlertViewController(alertTitle: "已編輯成功！"))
        MedicationReminderManager.shared.modifyMedicineInfo(reminderId: reminderIndex, medicineInfoUpdates: medicineInfoUpdates)
        
        for i in 0 ..< medicineInfoUpdates.count {
            if let viewToUpdate: ReminderNote = self.itemListView.arrangedSubviews.first(where: { ($0 as? ReminderNote)?.currentIndex == i }) as? ReminderNote {
                UIView.animate(withDuration: 0.3, animations: {
                    viewToUpdate.medicineNameText = medicineInfoUpdates[i].medicineName
                }) { _ in
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

extension MedReminderViewController: EditMedicineViewControllerDelegate {
    func editReminderClickSaveBtn(medicineAlias: [String], reminderIndex: String) {
        // show PanModal Alert
        presentPanModal(TransientAlertViewController(alertTitle: "已編輯成功！"))
        // Edit reminder medicineAlis
        MedicationReminderManager.shared.modifyMedicineInfoAlias(reminderId: reminderIndex, medicineAlias: medicineAlias)
    }
    
    func clickSaveBtn(medicineAlias: String, prescriptionCode: String) {
        // show PanModal Alert
        presentPanModal(TransientAlertViewController(alertTitle: "已編輯成功！"))
        
        for i in 0 ..< currentData.count {
            if prescriptionCode == currentData[i].cellInfo.prescriptionCode {
                currentData[i].cellInfo.medicineAlias = medicineAlias
                break
            }
        }
        
        currentData.forEach{
            $0.selectStatus = .noSelect
        }
        
        resetButtonsUI()
        
        tblView.beginUpdates()
        tblView.reloadData()
        tblView.endUpdates()
    }
}
