//
//  ManualSettingStep2ViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/19.
//

import UIKit
import KeychainSwift
import ProgressHUD
import PanModal

protocol ManualSettingStep2ViewControllerDelegate: AnyObject {
    func popPanModalAddSuccessAlert()
    func popPanModalSaveAllSuccessAlert()
    func popPanModalDeleteAllSuccessAlert()
}

extension ManualSettingStep2ViewControllerDelegate {
    func popPanModalAddSuccessAlert() {}
    func popPanModalSaveAllSuccessAlert() {}
    func popPanModalDeleteAllSuccessAlert() {}
}

class ManualSettingStep2ViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepUIView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineNicknameLabel: UILabel!
    @IBOutlet weak var medicineDoseLabel: UILabel!
    @IBOutlet weak var medicineUsageLabel: UILabel!
    
    @IBOutlet weak var firstSettingView: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var secondSettingView: UIView!
    @IBOutlet weak var freq1ImageView: UIImageView!
    @IBOutlet weak var freq2ImageView: UIImageView!
    @IBOutlet weak var freq3ImageView: UIImageView!
    @IBOutlet weak var weekOf1Button: UIButton!
    @IBOutlet weak var weekOf2Button: UIButton!
    @IBOutlet weak var weekOf3Button: UIButton!
    @IBOutlet weak var weekOf4Button: UIButton!
    @IBOutlet weak var weekOf5Button: UIButton!
    @IBOutlet weak var weekOf6Button: UIButton!
    @IBOutlet weak var weekOf7Button: UIButton!
    @IBOutlet weak var inputDayTextField: UITextField!
    
    @IBOutlet weak var thirdSettingView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    
    @IBOutlet weak var addTimeItemView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var addTimeLabel: UILabel!
    @IBOutlet weak var addTimeButton: UIButton!
    
    var isSelectWeekOf1Button: Bool = false {
        didSet {
            if isSelectWeekOf1Button {
                weekOf1Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf1Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf2Button: Bool = false {
        didSet {
            if isSelectWeekOf2Button {
                weekOf2Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf2Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf3Button: Bool = false {
        didSet {
            if isSelectWeekOf3Button {
                weekOf3Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf3Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf4Button: Bool = false {
        didSet {
            if isSelectWeekOf4Button {
                weekOf4Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf4Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf5Button: Bool = false {
        didSet {
            if isSelectWeekOf5Button {
                weekOf5Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf5Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf6Button: Bool = false {
        didSet {
            if isSelectWeekOf6Button {
                weekOf6Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf6Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var isSelectWeekOf7Button: Bool = false {
        didSet {
            if isSelectWeekOf7Button {
                weekOf7Button.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                weekOf7Button.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    
    var usagetime: Int?
    var takingTime: String = ""
    var currentSelectItems: [AddReminderCellViewModel] = []
    var currentReminder: MedicationReminder?
    var currentStartDate: String = ""
    var currentEndDate: String = ""
    var settingTimeArray: [String] = []
    var currentMedFrequency: FrequencyType = .daily
    var currentInterval: String = ""
    weak var delegate: ManualSettingStep2ViewControllerDelegate?
    var rspItem: ReminderRspModel?
    var reminderSettingRspItem: ReminderSettingRspModel?
    var retryExecuted: Bool = false
    var gPrescriptionInfo: PrescriptionInfo?
    var isPushedFromMedResultVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        
        if isPushedFromMedResultVC {
            let alertViewController = UINib.load(nibName: "FixedVerifyResultAlertVC") as! FixedVerifyResultAlertVC
            alertViewController.delegate = self
            alertViewController.alertType = .importedReminder
            alertViewController.alertLabel.text = "藥品已匯入用藥提醒"
            alertViewController.alertBtn.setTitle("我知道了", for: .normal)
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            processNotSettingBasicFreqencyAndTimeFlow()
        }
        
        // 綁定 inputDayTextField 當編輯結束時觸發
        inputDayTextField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    // checkmarx
    @objc func processEndEditing(_ textField: UITextField) {
        if let intervalDay = textField.text {
            self.currentInterval = intervalDay
            
            if currentInterval.isEmpty {
                disableNextButton()
            } else {
                self.currentMedFrequency = .interval(days: self.currentInterval.integer)
                enableNextButton()
            }
        }
    }
    
    // checkmarx
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // checkmarx
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
        
        if isPushedFromMedResultVC {
            stepUIView.isHidden = true
            
            if SharingManager.sharedInstance.currAutoImportPrescriptionInfos.count > 0 {
                self.gPrescriptionInfo = SharingManager.sharedInstance.currAutoImportPrescriptionInfos[0]
                
                updateUIviaPrescriptionInfo(info: self.gPrescriptionInfo!)
            }
        } else if SharingManager.sharedInstance.currentSetReminderMode == .manual {
            stepUIView.isHidden = false
            
            if SharingManager.sharedInstance.currManualPrescriptionInfos.count > 0 {
                self.gPrescriptionInfo = SharingManager.sharedInstance.currManualPrescriptionInfos[0]
                
                updateUIviaPrescriptionInfo(info: self.gPrescriptionInfo!)
            }
        } else {
            stepUIView.isHidden = true
            
            if let reminderSettingRspItem = self.reminderSettingRspItem {
                updateUIviaReminderSettingRspData(reminderSetting: reminderSettingRspItem)
            }
        }
    }
    
    @objc override func popPresentedViewController() {
        if !isPushedFromMedResultVC {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "是否放棄設定並返回「用藥管理」?"
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("取消", for: .normal)
            alertViewController.cancelButton.setTitle("確認", for: .normal)
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        if SharingManager.sharedInstance.currentSetReminderMode == .edit {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "是否刪除本藥品的全部提醒?"
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("取消", for: .normal)
            alertViewController.cancelButton.setTitle("確認", for: .normal)
            alertViewController.alertType = .delete_single_reminder
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        if confirmInputDateIsLegal() {
            
            if SharingManager.sharedInstance.currentSetReminderMode == .edit {
                processEditMode()
            } else {
                processSettingMode()
            }
            
        } else {
            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
            alertViewController.delegate = self
            alertViewController.alertLabel.text = "結束時間不能早於開始時間"
            alertViewController.alertImageView.image = UIImage(named: "Error")
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func enableWeekGroupBtns(isEnable: Bool) {
        weekOf1Button.isEnabled = isEnable
        weekOf2Button.isEnabled = isEnable
        weekOf3Button.isEnabled = isEnable
        weekOf4Button.isEnabled = isEnable
        weekOf5Button.isEnabled = isEnable
        weekOf6Button.isEnabled = isEnable
        weekOf7Button.isEnabled = isEnable
    }
    
    func processFreq1Action() {
        freq1ImageView.image = UIImage(named: "RadioBtnSelect")
        freq2ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq3ImageView.image = UIImage(named: "RadioBtnNoSelect")
        
        enableWeekGroupBtns(isEnable: false)
        inputDayTextField.isEnabled = false
        
        currentMedFrequency = .daily
        enableNextButton()
    }
    
    @IBAction func clickFreq1Action(_ sender: UIButton) {
        processFreq1Action()
    }
    
    @IBAction func clickFreq2Action(_ sender: UIButton) {
        freq1ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq2ImageView.image = UIImage(named: "RadioBtnSelect")
        freq3ImageView.image = UIImage(named: "RadioBtnNoSelect")
        
        enableWeekGroupBtns(isEnable: true)
        inputDayTextField.isEnabled = false
        
        currentMedFrequency = .weekly(days: [])
        
        _ = checkAndEnableNextButton()
    }
    
    func checkAndEnableNextButton() -> Bool {
        var result: Bool = false
        
        if isSelectWeekOf1Button ||
            isSelectWeekOf2Button ||
            isSelectWeekOf3Button ||
            isSelectWeekOf4Button ||
            isSelectWeekOf5Button ||
            isSelectWeekOf3Button ||
            isSelectWeekOf7Button {
            enableNextButton()
            result = true
        } else {
            disableNextButton()
        }
        
        return result
    }
    
    func updateCurrentWeeklyFreqhency() {
        var dayArray: [String] = []
        
        if isSelectWeekOf1Button {
            dayArray.append(weekDaysMapping["週一"]!)
        }
        if isSelectWeekOf2Button {
            dayArray.append(weekDaysMapping["週二"]!)
        }
        if isSelectWeekOf3Button {
            dayArray.append(weekDaysMapping["週三"]!)
        }
        if isSelectWeekOf4Button {
            dayArray.append(weekDaysMapping["週四"]!)
        }
        if isSelectWeekOf5Button {
            dayArray.append(weekDaysMapping["週五"]!)
        }
        if isSelectWeekOf6Button {
            dayArray.append(weekDaysMapping["週六"]!)
        }
        if isSelectWeekOf7Button {
            dayArray.append(weekDaysMapping["週日"]!)
        }
        
        currentMedFrequency = .weekly(days: dayArray)
    }
    
    @IBAction func clickFreq3Action(_ sender: UIButton) {
        freq1ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq2ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq3ImageView.image = UIImage(named: "RadioBtnSelect")
        
        enableWeekGroupBtns(isEnable: false)
        inputDayTextField.isEnabled = true
        
        currentMedFrequency = .interval(days: 0)
        
        if currentInterval.isEmpty {
            disableNextButton()
        } else {
            enableNextButton()
        }
    }
    
    @IBAction func weekOf1Action(_ sender: Any) {
        isSelectWeekOf1Button = !isSelectWeekOf1Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf2Action(_ sender: Any) {
        isSelectWeekOf2Button = !isSelectWeekOf2Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf3Action(_ sender: Any) {
        isSelectWeekOf3Button = !isSelectWeekOf3Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf4Action(_ sender: Any) {
        isSelectWeekOf4Button = !isSelectWeekOf4Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf5Action(_ sender: Any) {
        isSelectWeekOf5Button = !isSelectWeekOf5Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf6Action(_ sender: Any) {
        isSelectWeekOf6Button = !isSelectWeekOf6Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf7Action(_ sender: Any) {
        isSelectWeekOf7Button = !isSelectWeekOf7Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    func checkIfOver24TimeSettingItem() -> (Bool, Int) {
        let viewCount = itemListView.arrangedSubviews.count
        
        if viewCount < 24 {
            return (true, viewCount)
        } else {
            return (false, 0)
        }
    }
    
    @IBAction func clickAddTimeItemAction(_ sender: UIButton) {
        let timeItemStatus: (Bool, Int) = checkIfOver24TimeSettingItem()
        
        if timeItemStatus.0 {
            self.setItemView(addBottomLine: true, itemIndex: timeItemStatus.1, addDelBtn: true)
            
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
            
            if timeItemStatus.1 == 23 {
                addImageView.image = UIImage(named: "Add_gray")
                addTimeButton.isEnabled = false
                addTimeLabel.textColor = UIColor(hex: "#C7C7C7", alpha: 1.0)
            } else {
                addImageView.image = UIImage(named: "Add_blue")
                addTimeButton.isEnabled = true
                addTimeLabel.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
            }
        }
    }
    
    func processSettingMode() {
        guard let currentPresInfo = self.gPrescriptionInfo else {
            return
        }
        
        MedicationReminderManager.shared.deleteAllReminders()
        
        var medNameArray: [String] = []
        var medIdArray: [Int] = []
        var medicineInfo: [MedicineInfo] = []
        
        self.currentStartDate = DateTimeUtils.convertDateToTimeString(srcDate: self.startDatePicker.date)
        self.currentEndDate = DateTimeUtils.convertDateToTimeString(srcDate: self.endDatePicker.date)
        
        if SharingManager.sharedInstance.currentSetReminderMode == .manual || isPushedFromMedResultVC {
            for i in 0 ..< itemListView.arrangedSubviews.count {
                let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[i] as! TakingTimeSelectView
                let timeStr: String = DateTimeUtils.convertDateToTimeString(srcDate: subViewInStack.timePicker.date, formate: "HH:mm")
                
                settingTimeArray.append(timeStr)
            }
            
            medNameArray.append(currentPresInfo.medicineName)
            
            let mItem: MedicineInfo = MedicineInfo(dose: currentPresInfo.dose, doseUnits: currentPresInfo.doseUnits, medicineName: currentPresInfo.medicineName, useTime: currentPresInfo.useTime, medicineNameAlias: currentPresInfo.medicineAlias)
            medicineInfo.append(mItem)
            medIdArray.append(1)
        }
        
        _ = MedicationReminderManager.shared.createReminder(
            reminderId: UUID().uuidString,
            medicationNames: medNameArray,
            medicationIds: medIdArray,
            frequencyType: currentMedFrequency,
            times: settingTimeArray,
            period: "\(self.currentStartDate)-\(self.currentEndDate)",
            startDate: self.currentStartDate,
            endDate: self.currentEndDate,
            medicineInfo: medicineInfo
        )
        
        requestCreateReminderSettings()
    }
    
    func processEditMode() {
        guard let reminderSettingRspItem = self.reminderSettingRspItem,
                let timeSettings = reminderSettingRspItem.reminderTimeSettings.dataArray else {
            return
        }
        
        self.currentStartDate = DateTimeUtils.convertDateToTimeString(srcDate: self.startDatePicker.date)
        self.currentEndDate = DateTimeUtils.convertDateToTimeString(srcDate: self.endDatePicker.date)
        
        var timeInfos: [TimeSettingBasicModel] = []
        var gWeeklyDays: [String] = ["1"]
        
        for i in 0 ..< timeSettings.count {
            let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[i] as! TakingTimeSelectView
            let timeStr: String = DateTimeUtils.convertDateToTimeString(srcDate: subViewInStack.timePicker.date, formate: "HH:mm")
            let timeItem: TimeSettingItem = timeSettings[i]
            let timeInfo: TimeSettingBasicModel = TimeSettingBasicModel(id: timeItem.id, remindTime: timeStr)
            
            timeInfos.append(timeInfo)
        }
        
        if let weeklyDays = currentMedFrequency.weeklyDays {
            gWeeklyDays = weeklyDays
        }
        
        // call API
        let reqInfo: ModifyReminderSettingModel = ModifyReminderSettingModel(reminderSettingId: reminderSettingRspItem.reminderSettingId, startDate: self.currentStartDate, endDate: self.currentEndDate, frequencyType: currentMedFrequency.apiParameter, reminderTimeSettings: timeInfos, type: "MEDICINE", frequencyWeekdays: gWeeklyDays, frequencyDays: self.currentInterval.integer)
        requestModifyMultiReminderSettings(request: reqInfo)
    }
    
    func processNotSettingBasicFreqencyAndTimeFlow() {
        // Check If setting reminder frequency and time
        if UserDefaults.standard.loadReminderTimeSetting() == nil {
            let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WorkRestTimeSettingVC") as! WorkRestTimeSettingVC
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ManualSettingStep2ViewController {
    func adjustSafeAreaInsets() {
        if let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            self.additionalSafeAreaInsets.bottom = bottomInset
        }
    }
    
    func updateUI() {
        // 移除所有 subView
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        scrollView.delegate = self
        
        topView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))

        //topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        
        firstSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        secondSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        thirdSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        processFreq1Action()
        resetButtonsUI()
        enableNextButton()
        
        startDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        endDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        
        //inputDayTextField.delegate = self
        
        if SharingManager.sharedInstance.currentSetReminderMode != .edit {
            /* 設置UIDatePicker的預設時間為一個月後 */
            
            // 獲取今天的日期
            let today = Date()
            
            // 計算一個月後的日期
            var dateComponents = DateComponents()
            dateComponents.month = 1
            let oneMonthLater = Calendar.current.date(byAdding: dateComponents, to: today)
            
            if let oneMonthLater = oneMonthLater {
                endDatePicker.date = oneMonthLater
            }
        }
        
        // 确保 contentView 延伸到底部，包括 Home Indicator 区域
        // adjustSafeAreaInsets()
    }
    
    /*
    func updateUIviaData(usagetime: Int) {
        for i in 0 ..< usagetime {
            
            if i == (usagetime - 1) {
                self.setItemView(addBottomLine: false, itemIndex: i)
            } else {
                self.setItemView(addBottomLine: true, itemIndex: i)
            }
        }
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.layoutIfNeeded()
    }
    */
    
    /*
    func updateUIviaReminderData(reminderInfo: MedicationReminder) {
        for i in 0 ..< reminderInfo.times.count {
            
            if i == (reminderInfo.times.count - 1) {
                self.setItemView(addBottomLine: false, itemIndex: i)
            } else {
                self.setItemView(addBottomLine: true, itemIndex: i)
            }
        }
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.layoutIfNeeded()
    }
    */
    
    func updateFrequencyViewUI(setting: ReminderSettingRspModel) {
        if setting.frequencyType == "DAILY" {
            processFreq1Action()
            
        } else if setting.frequencyType == "WEEKLY" {
            freq1ImageView.image = UIImage(named: "RadioBtnNoSelect")
            freq2ImageView.image = UIImage(named: "RadioBtnSelect")
            freq3ImageView.image = UIImage(named: "RadioBtnNoSelect")
            
            enableWeekGroupBtns(isEnable: true)
            inputDayTextField.isEnabled = false
            
            for i in 0 ..< setting.frequencyWeekdays.count {
                let weekday: Int = setting.frequencyWeekdays[i]
                
                switch weekday {
                case 1:
                    isSelectWeekOf1Button = true
                case 2:
                    isSelectWeekOf2Button = true
                case 3:
                    isSelectWeekOf3Button = true
                case 4:
                    isSelectWeekOf4Button = true
                case 5:
                    isSelectWeekOf5Button = true
                case 6:
                    isSelectWeekOf6Button = true
                case 7:
                    isSelectWeekOf7Button = true
                default:
                    break
                }
            }
            
            updateCurrentWeeklyFreqhency()
            _ = checkAndEnableNextButton()
            
        } else if setting.frequencyType == "DAY_PERIOD" {
            freq1ImageView.image = UIImage(named: "RadioBtnNoSelect")
            freq2ImageView.image = UIImage(named: "RadioBtnNoSelect")
            freq3ImageView.image = UIImage(named: "RadioBtnSelect")
            
            enableWeekGroupBtns(isEnable: false)
            inputDayTextField.isEnabled = true
            
            self.currentInterval = "\(setting.frequencyDays)"
            self.currentMedFrequency = .interval(days: setting.frequencyDays)
            
            enableNextButton()
        }
    }
    
    func updateUIviaPrescriptionInfo(info: PrescriptionInfo) {
        medicineNameLabel.text = info.medicineName
        medicineNicknameLabel.text = info.medicineAlias
        medicineDoseLabel.text = "\(info.dose)\(info.doseUnits)"
        medicineUsageLabel.text = takingTimeCodeMapping[info.useTime] ?? "飯後"
        self.takingTime = takingTimeCodeMapping[info.useTime] ?? "飯後"
        
        if info.frequencyTimes == -1 {
            // 24 time item flow
            self.setItemView(addBottomLine: true, itemIndex: 0, addDelBtn: true)
            self.addTimeItemView.isHidden = false
        } else {
            // create time setting item via frequencyTimes
            for i in 0 ..< info.frequencyTimes {
                if i == (info.frequencyTimes - 1) {
                    self.setItemView(addBottomLine: false, itemIndex: i)
                } else {
                    self.setItemView(addBottomLine: true, itemIndex: i)
                }
            }
            self.addTimeItemView.isHidden = true
        }
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    func updateUIviaReminderSettingRspData(reminderSetting: ReminderSettingRspModel) {
        guard let timeSettings = reminderSetting.reminderTimeSettings.dataArray else {
            return
        }
        
        for i in 0 ..< timeSettings.count {
            if i == (timeSettings.count - 1) {
                self.setItemView(addBottomLine: false, itemIndex: i, timeInfos: timeSettings)
            } else {
                self.setItemView(addBottomLine: true, itemIndex: i, timeInfos: timeSettings)
            }
        }
        
        medicineNameLabel.text = reminderSetting.reminderSettingMedicineInfo.medicineName
        medicineNicknameLabel.text = reminderSetting.reminderSettingMedicineInfo.medicineNameAlias
        medicineDoseLabel.text = "\(reminderSetting.reminderSettingMedicineInfo.dose)\(reminderSetting.reminderSettingMedicineInfo.doseUnits)"
        medicineUsageLabel.text = takingTimeCodeMapping[reminderSetting.reminderSettingMedicineInfo.useTime] ?? "飯後"
        
        if DateTimeUtils.isDateBeforeToday(dateString: reminderSetting.startDate) != nil {
            if DateTimeUtils.isDateBeforeToday(dateString: reminderSetting.startDate)! {
                startDatePicker.isEnabled = false
                startDatePicker.date = Date()
            } else {
                startDatePicker.isEnabled = true
                startDatePicker.date = DateTimeUtils.convertStringToDate(dateString: reminderSetting.startDate)
            }
        }
        
        let today = Date()
        startDatePicker.minimumDate = today
        
        endDatePicker.date = DateTimeUtils.convertStringToDate(dateString: reminderSetting.endDate)
        
        updateFrequencyViewUI(setting: reminderSetting)
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    func resetButtonsUI() {
        cancelButton.isEnabled = true
        cancelButton.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        cancelButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
        cancelButton.layer.borderWidth = 1.0
        
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        nextButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.layer.borderWidth = 1.0
        
        if SharingManager.sharedInstance.currentSetReminderMode == .edit {
            cancelButton.setTitle("刪除", for: .normal)
            nextButton.setTitle("儲存", for: .normal)
        } else {
            cancelButton.setTitle("取消", for: .normal)
            nextButton.setTitle("設定完成", for: .normal)
        }
    }
    
    func enableNextButton() {
        nextButton.isEnabled = true
        nextButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        nextButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
    }
    
    func disableNextButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
    }
    
    func confirmInputDateIsLegal() -> Bool {
        if DateTimeUtils.compareDatesByYearMonthDay(date1: self.endDatePicker.date, date2: self.startDatePicker.date) {
            return false
        } else {
            return true
        }
    }
}

extension ManualSettingStep2ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension ManualSettingStep2ViewController: VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {
        if alertType == .importedReminder {
            processNotSettingBasicFreqencyAndTimeFlow()
        }
    }
}

extension ManualSettingStep2ViewController: TakingTimeSelectViewDelegate {
    func clickDeleteBtn(itemIndex: Int) {
        let viewCount = itemListView.arrangedSubviews.count
        
        if viewCount > 1 {
            self.onRemove(viewWithIndex: itemIndex)
            
            let timeItemStatus: (Bool, Int) = checkIfOver24TimeSettingItem()
            if timeItemStatus.0 {
                 if timeItemStatus.1 == 23 {
                     addImageView.image = UIImage(named: "Add_blue")
                     addTimeButton.isEnabled = true
                     addTimeLabel.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
                }
            }
            
        } else  {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "必須保留一個服用時間"
            alertViewController.isKeyButtonLeft = true
            alertViewController.confirmButton.setTitle("確定", for: .normal)
            alertViewController.cancelButton.isHidden = true
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension ManualSettingStep2ViewController {
    func setDefaultTimes(time: String, srcTimePicker: UIDatePicker) {
        let timeWithoutSeconds = String(time.prefix(5))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: timeWithoutSeconds) else {
            fatalError("Unknown Time Format!")
        }
        srcTimePicker.date = date
    }
    
    func setDefaultTimes(timePickerIndex: Int, srcTimePicker: UIDatePicker) {
        let workAndRestSettings: WorkAndRestTimeSettings = UserDefaults.standard.loadWorkAndRestTimeSettings() ?? WorkAndRestTimeSettings(breakfast: "08:00", lunch: "12:00", dinner: "18:00", bedtime: "21:30")
        let reminderSettings: ReminderTimeSetting = UserDefaults.standard.loadReminderTimeSetting() ?? ReminderTimeSetting(beforeMeal: 30, afterMeal: 30, beforeBed: 30)
        
        switch timePickerIndex {
        case 0:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.breakfast, minuteSetting: reminderSettings)
            break
        case 1:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.lunch, minuteSetting: reminderSettings)
            break
        case 2:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.dinner, minuteSetting: reminderSettings)
            break
        case 3:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.bedtime, minuteSetting: reminderSettings)
            break
        default:
            break
        }
    }
    
    func calculateTime(baseTime: String, minuteSetting: ReminderTimeSetting) -> Date {
        var offset: Int = 0
        
        if self.takingTime == "飯前" {
            offset = -minuteSetting.beforeMeal
        } else if self.takingTime == "飯後" {
            offset = minuteSetting.afterMeal
        } else if self.takingTime == "睡前" {
            offset = -minuteSetting.beforeBed
        } else {
            // ???
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: baseTime) else {
            fatalError("Unknown Time Format!")
        }
        
        return Calendar.current.date(byAdding: .minute, value: offset, to: date)!
    }
    
    func setItemView(addBottomLine: Bool, itemIndex: Int, timeInfos: [TimeSettingItem] = [], addDelBtn: Bool = false) {
        let view = TakingTimeSelectView()
        
        view.itemText = "時間"
        view.hasDeleteBtn = addDelBtn
        view.currentIndex = itemIndex
        view.delegate = self
        view.timePicker.locale = Locale(identifier: "zh-Hant_TW")
        
        if timeInfos.count > 0 {
            setDefaultTimes(time: timeInfos[itemIndex].remindTime,
                            srcTimePicker: view.timePicker)
        } else {
            if itemIndex >= 0 && itemIndex < 4 {
                setDefaultTimes(timePickerIndex: itemIndex, srcTimePicker: view.timePicker)
            } else {
                view.timePicker.date = Date()
            }
        }
        
        view.addBottomLine = addBottomLine
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 62.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: TakingTimeSelectView) {
        if let first = self.itemListView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func onRemove(viewWithIndex index: Int) {
        if let viewToRemove = self.itemListView.arrangedSubviews.first(where: { ($0 as? TakingTimeSelectView)?.currentIndex == index }) {
            UIView.animate(withDuration: 0.3, animations: {
                viewToRemove.isHidden = true
                viewToRemove.removeFromSuperview()
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ManualSettingStep2ViewController: WorkRestTimeSettingVCDelegate {
    func presentNextSettingView() {
        let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReminderTimeSettingVC") as! ReminderTimeSettingVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension ManualSettingStep2ViewController: ReminderTimeSettingVCDelegate {
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

extension ManualSettingStep2ViewController: SettingCompleteVCDelegate {
    func presentFrequencySettingView() {
        // ???
    }
}

extension ManualSettingStep2ViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .delete_single_reminder {
            // call API
            if let reminderSettingRspItem = self.reminderSettingRspItem {
                let request: DelReminderSettingIdModel = DelReminderSettingIdModel(reminderSettingId: reminderSettingRspItem.reminderSettingId)
                
                requestDeleteMultiReminderSettings(request: request)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ManualSettingStep2ViewController {
    func requestModifyMultiReminderSettings(request: ModifyReminderSettingModel) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.modifyReminderSetting(request) {
            (responseModel: PhiResponseModel<ModifyReminderSettingRspModel>) in
            
            if responseModel.success {
                guard let modifyReminderSettingRspInfo = responseModel.data else {
                    return
                }
                
                print("modifyReminderSettingRspInfo.reminderSettingId=\(modifyReminderSettingRspInfo.reminderSettingId)")
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController({
                        self.presentPanModal(TransientAlertViewController(alertTitle: "已儲存成功!"))
                    })
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.requestModifyMultiReminderSettings(request: request)
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
    
    func requestDeleteMultiReminderSettings(request: DelReminderSettingIdModel) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.deleteReminderSetting(request) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            if responseModel.success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.requestDeleteMultiReminderSettings(request: request)
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

extension ManualSettingStep2ViewController {
    func popToSecondViewController() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            
            if viewControllers.count > 2 {
                // 獲取目標 ViewController
                let secondViewController = viewControllers[viewControllers.count - 3]
                
                // 設置新的 ViewController stack
                navigationController.setViewControllers([viewControllers.first!, secondViewController], animated: true)
                
                // 回調 delegate 方法
                delegate?.popPanModalAddSuccessAlert()
            }
        }
    }

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
                
                if self.isPushedFromMedResultVC {
                    DispatchQueue.main.async {
                        SharingManager.sharedInstance.reminderPushToMedicationManagementPage = true
                        self.navigationController?.popToRootViewController({
                            if let mostTopViewController = SDKUtils.mostTopViewController,
                               let tabBarController = (mostTopViewController as? MainTabBarController) ?? mostTopViewController.presentingViewController as? MainTabBarController {
                                tabBarController.selectedIndex = 1
                            }
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        SharingManager.sharedInstance.reminderPushToMedicationManagementPage = true
                        self.navigationController?.popToRootViewController({
                            // WFI
                        })
                    }
                    
                    // Somtimes cause UI issus
                    /*
                    DispatchQueue.main.async {
                        self.popToSecondViewController()
                    }
                    */
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
