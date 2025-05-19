//
//  NewSetttStep2VC..swift
//  phi-ios
//
//  Created by Kenneth Wu on 2025/2/12.
//

import UIKit
import KeychainSwift
import ProgressHUD
import PanModal

protocol NewSetttStep2VCDelegate: AnyObject {
    func popPanModalAddSuccessAlert()
    func popPanModalSaveAllSuccessAlert()
    func popPanModalDeleteAllSuccessAlert()
}

extension NewSetttStep2VCDelegate {
    func popPanModalAddSuccessAlert() {}
    func popPanModalSaveAllSuccessAlert() {}
    func popPanModalDeleteAllSuccessAlert() {}
}

class NewSetttStep2VC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepUIView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    //@IBOutlet weak var medicineNicknameLabel: UILabel!
    @IBOutlet weak var medicineDoseLabel: UILabel!
    @IBOutlet weak var medicineUsageLabel: UILabel!
    
    @IBOutlet weak var firstSettingView: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var secondSettingView: UIView!
    @IBOutlet weak var freq1ImageView: UIImageView!
    @IBOutlet weak var freq2ImageView: UIImageView!
    @IBOutlet weak var freq3ImageView: UIImageView!
    @IBOutlet var dayOfWeekViews: [UIView]!
    @IBOutlet var dayOfWeekTexts: [UILabel]!
    @IBOutlet var dayOfWeekImageViews: [UIImageView]!
    @IBOutlet weak var weekSubView: UIView!
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
    
    @IBOutlet weak var specifiedDateImageView: UIImageView!
    @IBOutlet weak var specifiedDateView: UIView!
    
    var isSelectWeekOf1Button: Bool = false {
        didSet {
            if isSelectWeekOf1Button {
                dayOfWeekViews[0].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[0].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[0].isHidden = false
            } else {
                dayOfWeekViews[0].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[0].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[0].isHidden = true
            }
        }
    }
    var isSelectWeekOf2Button: Bool = false {
        didSet {
            if isSelectWeekOf2Button {
                dayOfWeekViews[1].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[1].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[1].isHidden = false
            } else {
                dayOfWeekViews[1].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[1].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[1].isHidden = true
            }
        }
    }
    var isSelectWeekOf3Button: Bool = false {
        didSet {
            if isSelectWeekOf3Button {
                dayOfWeekViews[2].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[2].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[2].isHidden = false
            } else {
                dayOfWeekViews[2].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[2].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[2].isHidden = true
            }
        }
    }
    var isSelectWeekOf4Button: Bool = false {
        didSet {
            if isSelectWeekOf4Button {
                dayOfWeekViews[3].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[3].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[3].isHidden = false
            } else {
                dayOfWeekViews[3].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[3].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[3].isHidden = true
            }
        }
    }
    var isSelectWeekOf5Button: Bool = false {
        didSet {
            if isSelectWeekOf5Button {
                dayOfWeekViews[4].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[4].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[4].isHidden = false
            } else {
                dayOfWeekViews[4].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[4].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[4].isHidden = true
            }
        }
    }
    var isSelectWeekOf6Button: Bool = false {
        didSet {
            if isSelectWeekOf6Button {
                dayOfWeekViews[5].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[5].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[5].isHidden = false
            } else {
                dayOfWeekViews[5].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[5].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[5].isHidden = true
            }
        }
    }
    var isSelectWeekOf7Button: Bool = false {
        didSet {
            if isSelectWeekOf7Button {
                dayOfWeekViews[6].backgroundColor = UIColor.selectedBackgroundColor
                dayOfWeekTexts[6].textColor = UIColor.selectedTextColor
                dayOfWeekImageViews[6].isHidden = false
            } else {
                dayOfWeekViews[6].backgroundColor = UIColor.unSelectedBackgroundColor
                dayOfWeekTexts[6].textColor = UIColor.unSelectedTextColor
                dayOfWeekImageViews[6].isHidden = true
            }
        }
    }
    
    var isSelectSpecifiedDate: Bool = false {
        didSet {
            if isSelectSpecifiedDate {
                specifiedDateImageView.image = UIImage(named: "checkbox_active_20x20")
                specifiedDateView.isHidden = false
            } else {
                specifiedDateImageView.image = UIImage(named: "checkbox_default_20x20")
                specifiedDateView.isHidden = true
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
    weak var delegate: NewSetttStep2VCDelegate?
    var rspItem: ReminderRspModel?
    var reminderSettingRspItem: ReminderSettingRspModel?
    var retryExecuted: Bool = false
    var gPrescriptionInfo: PrescriptionInfo?
    var isPushedFromMedResultVC: Bool = false
    // 手動建立 UIButton 陣列
    var dayButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        if SharingManager.sharedInstance.currentSetReminderMode == .edit {
            createRightBarButtonViaImage(imageName: "delete_icon_black")
            title = "用藥編輯"
        } else {
            title = "用藥頻率設定"
        }
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
    
    @objc override func rightBarButtonTapped() {
        processDeleteAllReminder()
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
            topView.isHidden = true
            
            if SharingManager.sharedInstance.currAutoImportPrescriptionInfos.count > 0 {
                self.gPrescriptionInfo = SharingManager.sharedInstance.currAutoImportPrescriptionInfos[0]
                
                updateUIviaPrescriptionInfo(info: self.gPrescriptionInfo!)
            }
        } else if SharingManager.sharedInstance.currentSetReminderMode == .manual {
            stepUIView.isHidden = false
            topView.isHidden = true
            
            if SharingManager.sharedInstance.currManualPrescriptionInfos.count > 0 {
                self.gPrescriptionInfo = SharingManager.sharedInstance.currManualPrescriptionInfos[0]
                
                updateUIviaPrescriptionInfo(info: self.gPrescriptionInfo!)
            }
        } else {
            stepUIView.isHidden = true
            topView.isHidden = false
            
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
    
    func processDeleteAllReminder() {
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
    
    @IBAction func cancelAction(_ sender: UIButton) {
        processDeleteAllReminder()
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
        weekSubView.isHidden = !isEnable
    }
    
    func processFreq1Action() {
        freq1ImageView.image = UIImage(named: "RadioBtnSelect")
        freq2ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq3ImageView.image = UIImage(named: "RadioBtnNoSelect")
        
        enableWeekGroupBtns(isEnable: false)
        inputDayTextField.isEnabled = false
        
        currentMedFrequency = .daily
        currentInterval = "0"
        enableNextButton()
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
            dayArray.append(weekDaysMapping["週日"]!)
        }
        if isSelectWeekOf2Button {
            dayArray.append(weekDaysMapping["週一"]!)
        }
        if isSelectWeekOf3Button {
            dayArray.append(weekDaysMapping["週二"]!)
        }
        if isSelectWeekOf4Button {
            dayArray.append(weekDaysMapping["週三"]!)
        }
        if isSelectWeekOf5Button {
            dayArray.append(weekDaysMapping["週四"]!)
        }
        if isSelectWeekOf6Button {
            dayArray.append(weekDaysMapping["週五"]!)
        }
        if isSelectWeekOf7Button {
            dayArray.append(weekDaysMapping["週六"]!)
        }
        
        currentMedFrequency = .weekly(days: dayArray)
    }
    
    @IBAction func clickFreq1Action(_ sender: UIButton) {
        processFreq1Action()
    }
    
    @IBAction func clickFreq2Action(_ sender: UIButton) {
        freq1ImageView.image = UIImage(named: "RadioBtnNoSelect")
        freq2ImageView.image = UIImage(named: "RadioBtnSelect")
        freq3ImageView.image = UIImage(named: "RadioBtnNoSelect")
        
        enableWeekGroupBtns(isEnable: true)
        // Default enable 週一, 週三, 週五
        isSelectWeekOf2Button = true
        isSelectWeekOf4Button = true
        isSelectWeekOf6Button = true
        inputDayTextField.isEnabled = false
        
        var dayArray: [String] = []
        
        dayArray.append(weekDaysMapping["週一"]!)
        dayArray.append(weekDaysMapping["週三"]!)
        dayArray.append(weekDaysMapping["週五"]!)
        
        currentMedFrequency = .weekly(days: dayArray)
        // currentMedFrequency = .weekly(days: [])
        _ = checkAndEnableNextButton()
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
        // 日
        isSelectWeekOf1Button = !isSelectWeekOf1Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf2Action(_ sender: Any) {
        // 一
        isSelectWeekOf2Button = !isSelectWeekOf2Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf3Action(_ sender: Any) {
        // 二
        isSelectWeekOf3Button = !isSelectWeekOf3Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf4Action(_ sender: Any) {
        // 三
        isSelectWeekOf4Button = !isSelectWeekOf4Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf5Action(_ sender: Any) {
        // 四
        isSelectWeekOf5Button = !isSelectWeekOf5Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf6Action(_ sender: Any) {
        // 五
        isSelectWeekOf6Button = !isSelectWeekOf6Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func weekOf7Action(_ sender: Any) {
        // 六
        isSelectWeekOf7Button = !isSelectWeekOf7Button
        updateCurrentWeeklyFreqhency()
        _ = checkAndEnableNextButton()
    }
    
    @IBAction func clickSpecifiedDateAction(_ sender: UIButton) {
        isSelectSpecifiedDate = !isSelectSpecifiedDate
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

extension NewSetttStep2VC {
    func adjustSafeAreaInsets() {
        if let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            self.additionalSafeAreaInsets.bottom = bottomInset
        }
    }
    
    private func setupDayOfWeekViews() {
        for uview in dayOfWeekViews {
            uview.layer.cornerRadius = 8
            uview.backgroundColor = UIColor(hex: "#EBF5FB", alpha: 1.0)
        }
        for label in dayOfWeekTexts {
            label.textColor = UIColor(hex: "#434A4E", alpha: 1.0)
        }
        for image in dayOfWeekImageViews {
            image.isHidden = true
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
        
        if SharingManager.sharedInstance.currentSetReminderMode != .edit {
            thirdSettingView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        }
        thirdSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        addTimeItemView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        addTimeItemView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        //cellBaseView.layer.cornerRadius = 0
        //cellBaseView.layer.maskedCorners = []
        //cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        weekSubView.isHidden = true
        // 把 7 個按鈕放進陣列（按照順序對應 dayOfWeekViews）
        dayButtons = [weekOf1Button, weekOf2Button, weekOf3Button, weekOf4Button, weekOf5Button, weekOf6Button, weekOf7Button]
        setupDayOfWeekViews()
        specifiedDateView.isHidden = true
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
                case 7:
                    isSelectWeekOf1Button = true
                case 1:
                    isSelectWeekOf2Button = true
                case 2:
                    isSelectWeekOf3Button = true
                case 3:
                    isSelectWeekOf4Button = true
                case 4:
                    isSelectWeekOf5Button = true
                case 5:
                    isSelectWeekOf6Button = true
                case 6:
                    isSelectWeekOf7Button = true
                default:
                    break
                }
            }
            
            updateCurrentWeeklyFreqhency()
            self.currentInterval = "0"
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
        //medicineNicknameLabel.text = info.medicineAlias
        medicineDoseLabel.text = "\(info.dose)\(info.doseUnits)"
        medicineUsageLabel.text = takingTimeCodeMapping[info.useTime] ?? "飯後"
        self.takingTime = takingTimeCodeMapping[info.useTime] ?? "飯後"
        
        // K_0213_2025, Modify
        self.setItemView(addBottomLine: true, itemIndex: 0, addDelBtn: true)
        
        if SharingManager.sharedInstance.currentSetReminderMode == .edit {
            self.addTimeItemView.isHidden = true
        } else {
            self.addTimeItemView.isHidden = false
        }
        
        /*
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
         */
        
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
        //medicineNicknameLabel.text = reminderSetting.reminderSettingMedicineInfo.medicineNameAlias
        medicineDoseLabel.text = "\(reminderSetting.reminderSettingMedicineInfo.dose.cleanString)\(reminderSetting.reminderSettingMedicineInfo.doseUnits)"
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
        
        if SharingManager.sharedInstance.currentSetReminderMode == .edit {
            self.addTimeItemView.isHidden = true
        } else {
            self.addTimeItemView.isHidden = false
        }
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

extension NewSetttStep2VC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension NewSetttStep2VC: VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {
        if alertType == .importedReminder {
            processNotSettingBasicFreqencyAndTimeFlow()
        }
    }
}

extension NewSetttStep2VC: TakingTimeSelectViewDelegate {
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

extension NewSetttStep2VC {
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
        //view.addviewShadow = true
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

extension NewSetttStep2VC: WorkRestTimeSettingVCDelegate {
    func presentNextSettingView() {
        let storyboard = UIStoryboard(name: "TimeSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReminderTimeSettingVC") as! ReminderTimeSettingVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension NewSetttStep2VC: ReminderTimeSettingVCDelegate {
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

extension NewSetttStep2VC: SettingCompleteVCDelegate {
    func presentFrequencySettingView() {
        // ???
    }
}

extension NewSetttStep2VC: TwoButtonAlertVCDelegate {
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

extension NewSetttStep2VC {
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

extension NewSetttStep2VC {
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
