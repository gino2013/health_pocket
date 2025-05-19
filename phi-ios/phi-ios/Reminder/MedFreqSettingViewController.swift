//
//  MedFreqSettingViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/9.
//

import UIKit

enum MedicationFrequencyType: Int {
    case everyDay
    case everyWeek
    case everyInterval
}

protocol MedFreqSettingViewControllerDelegate: AnyObject {
    func popPanModalAlert()
}

class MedFreqSettingViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    /*
     @IBOutlet weak var time1Picker: UIDatePicker!
     @IBOutlet weak var time2Picker: UIDatePicker!
     @IBOutlet weak var time3Picker: UIDatePicker!
     @IBOutlet weak var timeOneView: UIView!
     @IBOutlet weak var lineOneView: UIView!
     @IBOutlet weak var timeTwoView: UIView!
     @IBOutlet weak var lineTwoView: UIView!
     @IBOutlet weak var timeThreeView: UIView!
     */
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var addTimeItemView: UIView!
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
    weak var delegate: MedFreqSettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checkmarx
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
        
        UIView.animate(withDuration: 0.126) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        if let usagetime = self.usagetime {
            print("usagetime = \(usagetime)!")
            updateUIviaData(usagetime: usagetime)
        } else if let currentReminder = self.currentReminder {
            print("times.count = \(currentReminder.times.count)!")
            updateUIviaReminderData(reminderInfo: currentReminder)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .clear
        // checkmarx
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //
        }
    }
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        if confirmInputDateIsLegal() {
            var medNameArray: [String] = []
            var medIdArray: [Int] = []
            var medicineInfo: [MedicineInfo] = []
            
            self.currentStartDate = convertStartDateToTimeString()
            self.currentEndDate = convertEndDateToTimeString()
            
            if let _ = self.usagetime {
                for i in 0 ..< itemListView.arrangedSubviews.count {
                    let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[i] as! TakingTimeSelectView
                    let timeStr: String = convertTimeToTimeString(srcPicker: subViewInStack.timePicker)
                    
                    settingTimeArray.append(timeStr)
                }
                for i in 0 ..< currentSelectItems.count {
                    let item: PrescriptionInfo = currentSelectItems[i].cellInfo
                    let mItem: MedicineInfo = MedicineInfo(dose: item.dose, doseUnits: item.doseUnits, medicineName: item.medicineName, useTime: item.useTime, medicineNameAlias: item.medicineAlias)
                    
                    medNameArray.append(item.medicineName)
                    medIdArray.append(currentSelectItems[i].cellId)
                    medicineInfo.append(mItem)
                }
            } else if let currentReminder = self.currentReminder {
                for i in 0 ..< currentReminder.times.count {
                    let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[i] as! TakingTimeSelectView
                    let timeStr: String = convertTimeToTimeString(srcPicker: subViewInStack.timePicker)
                    
                    settingTimeArray.append(timeStr)
                }
            }
            
            if let currentReminder = self.currentReminder {
                // Edit Mode
                MedicationReminderManager.shared.editReminder(
                    reminderId: currentReminder.reminderId,
                    medicationNames: currentReminder.medicationNames,
                    medicationIds: currentReminder.medicationIds,
                    frequencyType: currentMedFrequency,
                    times: settingTimeArray,
                    period: "\(self.currentStartDate)-\(self.currentEndDate)")
            } else {
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
            }
            
            self.dismiss(animated: true) {
                self.delegate?.popPanModalAlert()
            }
        } else {
            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
            //alertViewController.delegate = self
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
}

extension MedFreqSettingViewController {
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
        
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
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
        // 設置UIDatePicker的預設時間為一個月後
        // 獲取今天的日期
        let today = Date()
        // 計算一個月後的日期
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let oneMonthLater = Calendar.current.date(byAdding: dateComponents, to: today)
        
        if let oneMonthLater = oneMonthLater {
            endDatePicker.date = oneMonthLater
        }
        
        // inputDayTextField.delegate = self
        
        // 确保 contentView 延伸到底部，包括 Home Indicator 区域
        // adjustSafeAreaInsets()
    }
    
    func updateUIviaData(usagetime: Int) {
        if usagetime == -1 {
            // 24 time item flow
            self.setItemView(addBottomLine: true, itemIndex: 0, addDelBtn: true)
            self.addTimeItemView.isHidden = false
        } else {
            for i in 0 ..< usagetime {
                if i == (usagetime - 1) {
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
        nextButton.setTitle("設定完成", for: .normal)
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
    
    func convertStartDateToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let selectedDate = dateFormatter.string(from: self.startDatePicker.date)
        
        return selectedDate
    }
    
    func convertEndDateToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let selectedDate = dateFormatter.string(from: self.endDatePicker.date)
        
        return selectedDate
    }
    
    func convertTimeToTimeString(srcPicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.string(from: srcPicker.date)
        
        return selectedTime
    }
}

extension MedFreqSettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension MedFreqSettingViewController: TakingTimeSelectViewDelegate {
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
            //alertViewController.delegate = self
            alertViewController.messageLabel.text = "必須保留一個服用時間"
            alertViewController.isKeyButtonLeft = true
            alertViewController.confirmButton.setTitle("確定", for: .normal)
            alertViewController.cancelButton.isHidden = true
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension MedFreqSettingViewController {
    func setDefaultTimes(timePickerIndex: Int, srcTimePicker: UIDatePicker) {
        let workAndRestSettings: WorkAndRestTimeSettings = UserDefaults.standard.loadWorkAndRestTimeSettings() ?? WorkAndRestTimeSettings(breakfast: "08:00", lunch: "12:00", dinner: "18:00", bedtime: "21:30")
        let reminderSettings: ReminderTimeSetting = UserDefaults.standard.loadReminderTimeSetting() ?? ReminderTimeSetting(beforeMeal: 30, afterMeal: 30, beforeBed: 30)
        
        switch timePickerIndex {
        case 0:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.breakfast, minuteSetting: reminderSettings)
            break
        case 1:
            srcTimePicker.date = calculateTime(baseTime: workAndRestSettings.lunch  , minuteSetting: reminderSettings)
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
            let timeWithoutSec: String = String(timeInfos[itemIndex].remindTime.prefix(5))
            view.timePicker.date = DateTimeUtils.convertStringToDate(dateString: timeWithoutSec, format: "HH:mm")
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
