//
//  ScheduleSettingViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/7.
//

import UIKit
import KeychainSwift
import ProgressHUD

class ScheduleSettingViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstSettingView: UIView!
    @IBOutlet weak var time1Picker: UIDatePicker!
    @IBOutlet weak var time2Picker: UIDatePicker!
    @IBOutlet weak var time3Picker: UIDatePicker!
    @IBOutlet weak var time4Picker: UIDatePicker!
    @IBOutlet weak var timeOneView: UIView!
    @IBOutlet weak var lineOneView: UIView!
    @IBOutlet weak var timeTwoView: UIView!
    @IBOutlet weak var lineTwoView: UIView!
    @IBOutlet weak var timeThreeView: UIView!
    @IBOutlet weak var lineThreeView: UIView!
    @IBOutlet weak var timeFourView: UIView!
    
    @IBOutlet weak var rangeSettingView: UIView!
    @IBOutlet weak var beforeMealTextField: UITextField!
    @IBOutlet weak var afterMealTextField: UITextField!
    @IBOutlet weak var beforeBedTextField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // 修改後的分鐘數組，每5分鐘一個選擇
    let minutes = Array(stride(from: 0, to: 60, by: 5))
    var activeTextField: UITextField?
    var pickerView: UIPickerView!
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        createRightBarButtonViaImage(imageName: "info_black")
        updateUI()
        updateTimePickersUI()
        updateRangePickerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // getRoutineTime()
        
        if UserDefaults.standard.loadWorkAndRestTimeSettings() == nil || UserDefaults.standard.loadReminderTimeSetting() == nil {
            // call API
            getRoutineTime()
        } else {
            // use local setting to update UI
            let reminderSettings: ReminderTimeSetting = UserDefaults.standard.loadReminderTimeSetting() ?? ReminderTimeSetting(beforeMeal: 30, afterMeal: 30, beforeBed: 30)
            
            beforeMealTextField.text = "\(reminderSettings.beforeMeal)"
            afterMealTextField.text = "\(reminderSettings.afterMeal)"
            beforeBedTextField.text = "\(reminderSettings.beforeBed)"
            
            setDefaultTimes(timePickerIndex: 0, srcTimePicker: time1Picker)
            setDefaultTimes(timePickerIndex: 1, srcTimePicker: time2Picker)
            setDefaultTimes(timePickerIndex: 2, srcTimePicker: time3Picker)
            setDefaultTimes(timePickerIndex: 3, srcTimePicker: time4Picker)
        }
    }
    
    @objc override func rightBarButtonTapped() {
        let alertViewController = UINib.load(nibName: "StopAuthAlertVC") as! StopAuthAlertVC
        alertViewController.mainImageView.image = UIImage(named: "Daily")
        alertViewController.mainLabel.text = "作息時間設定範例"
        alertViewController.messageLabel.textAlignment = .left
        
        let messageText = """
        1. 設定作息時間早餐為「8:00」，飯後提醒用藥為「30 分鐘後」
        2. 建立用藥時間為「早上／飯後」的藥品
        3. 用藥提醒時間將會自動帶入「8:30」
        """
        
        // 創建 NSMutableParagraphStyle 來設置段落樣式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 1 // 行距
        paragraphStyle.paragraphSpacing = 1 // 段落間距
        paragraphStyle.firstLineHeadIndent = 0 // 第一行不縮進
        paragraphStyle.headIndent = 15 // 設定後續行的縮進距離

        // 創建 NSMutableAttributedString
        let attributedString = NSMutableAttributedString(string: messageText)

        // 將段落樣式應用到整個文字
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        // 設定文字的 attributes 到 UILabel
        alertViewController.messageLabel.attributedText = attributedString
        // 調整 UILabel 大小以適應內容
        alertViewController.messageLabel.sizeToFit()
        
        alertViewController.confirmButton.setTitle("我知道了", for: .normal)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        saveTimeToUserDefaults()
        saveMinuteSettingToUserDefaults()
        
        // call API
        requestSetRoutineTime()
        
        let alertViewController = UINib.load(nibName: "StopAuthAlertVC") as! StopAuthAlertVC
        alertViewController.mainLabel.text = "儲存成功"
        alertViewController.messageLabel.text = "點擊確認後前往「全部」"
        alertViewController.delegate = self
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension ScheduleSettingViewController {
    func updateUI() {
        scrollView.delegate = self
        firstSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        rangeSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        resetButtonsUI()
        enableNextButton()
        // startDatePicker.locale = Locale(identifier: "zh-Hant_TW")
    }
    
    func resetButtonsUI() {
        deleteButton.isEnabled = true
        deleteButton.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
        deleteButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        deleteButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        deleteButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
        deleteButton.layer.borderWidth = 1.0
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderWidth = 1.0
        saveButton.setTitle("儲存", for: .normal)
    }
    
    func enableNextButton() {
        saveButton.isEnabled = true
        saveButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
    }
    
    func disableNextButton() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
    }
    
    // 完成按鈕的操作
    @objc func doneTapped() {
        activeTextField?.resignFirstResponder()
    }
}

extension ScheduleSettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension ScheduleSettingViewController {
    func updateTimePickersUI() {
        time1Picker.locale = Locale(identifier: "zh-Hant_TW")
        time2Picker.locale = Locale(identifier: "zh-Hant_TW")
        time3Picker.locale = Locale(identifier: "zh-Hant_TW")
        time4Picker.locale = Locale(identifier: "zh-Hant_TW")
        
        // 設置UIDatePicker的預設時間為早上8:30
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        if let date = calendar.date(from: dateComponents) {
            time1Picker.date = date
        }
        
        dateComponents.hour = 12
        dateComponents.minute = 0
        if let date = calendar.date(from: dateComponents) {
            time2Picker.date = date
        }
        
        dateComponents.hour = 18
        dateComponents.minute = 0
        if let date = calendar.date(from: dateComponents) {
            time3Picker.date = date
        }
        
        dateComponents.hour = 21
        dateComponents.minute = 30
        if let date = calendar.date(from: dateComponents) {
            time4Picker.date = date
        }
    }
    
    func updateRangePickerUI() {
        beforeMealTextField.borderStyle = .none
        afterMealTextField.borderStyle = .none
        beforeBedTextField.borderStyle = .none
        
        beforeMealTextField.delegate = self
        afterMealTextField.delegate = self
        beforeBedTextField.delegate = self
        
        // 設置 PickerView
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // 將 PickerView 設置為 TextField 的 inputView
        beforeMealTextField.inputView = pickerView
        afterMealTextField.inputView = pickerView
        beforeBedTextField.inputView = pickerView
        
        // 添加一個完成按鈕的工具欄
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        //toolbar.setItems([doneButton], animated: true)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        beforeMealTextField.inputAccessoryView = toolbar
        afterMealTextField.inputAccessoryView = toolbar
        beforeBedTextField.inputAccessoryView = toolbar
    }
    
    func useDateToGetTime(src: Date) -> String {
        let selectedTime = src
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh-Hant_TW")
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: selectedTime)
        
        return timeString
    }
    
    func convertTimeToTimeString(srcPicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.string(from: srcPicker.date)
        
        return selectedTime
    }
    
    func saveTimeToUserDefaults() {
        // 取得UIDatePicker上的選定時間
        let timeInfo: WorkAndRestTimeSettings = WorkAndRestTimeSettings(
            breakfast: useDateToGetTime(src: time1Picker.date),
            lunch: useDateToGetTime(src: time2Picker.date),
            dinner: useDateToGetTime(src: time3Picker.date),
            bedtime: useDateToGetTime(src: time4Picker.date))
        
        UserDefaults.standard.saveWorkAndRestTimeSettings(timeInfo)
    }
    
    func saveMinuteSettingToUserDefaults() {
        if let beforeMeal = beforeMealTextField.text,
           let afterMeal = afterMealTextField.text,
           let beforeBed = beforeBedTextField.text {
            let settingInfo: ReminderTimeSetting = ReminderTimeSetting(beforeMeal: beforeMeal.integer, afterMeal: afterMeal.integer, beforeBed: beforeBed.integer)
            
            UserDefaults.standard.saveReminderTimeSetting(settingInfo)
        }
    }
    
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: baseTime) else {
            fatalError("Unknown Time Format!")
        }
        
        return Calendar.current.date(byAdding: .minute, value: offset, to: date)!
    }
}

extension ScheduleSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(minutes[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMinute = minutes[row]
        activeTextField?.text = "\(selectedMinute)"
    }
}

extension ScheduleSettingViewController: StopAuthAlertVCDelegate {
    func clickConfirmBtn() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ScheduleSettingViewController: VerifyResultAlertVCDelegate {
    func getRoutineTime() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.findRoutineTime() {
            (responseModel: PhiResponseModel<RoutineTimeInfoRspModel>) in
            
            if responseModel.success {
                guard let rspInfo = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    
                    self.time1Picker.date = dateFormatter.date(from: rspInfo.breakfastTime) ?? Date()
                    self.time2Picker.date = dateFormatter.date(from: rspInfo.lunchTime) ?? Date()
                    self.time3Picker.date = dateFormatter.date(from: rspInfo.dinnerTime) ?? Date()
                    self.time4Picker.date = dateFormatter.date(from: rspInfo.bedtimeTime) ?? Date()
                    
                    self.beforeMealTextField.text = "\(rspInfo.mealBefore)"
                    self.afterMealTextField.text = "\(rspInfo.mealAfter)"
                    self.beforeBedTextField.text = "\(rspInfo.bedtimeBefore)"
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getRoutineTime()
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.delegate = self
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
    
    func requestSetRoutineTime() {
        guard let beforeMeal = beforeMealTextField.text,
              let afterMeal = afterMealTextField.text,
              let beforeBed = beforeBedTextField.text else {
            return
        }
        
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)

        let reqInfo: SetupRoutineTimeModel = SetupRoutineTimeModel(
            breakfastTime: useDateToGetTime(src: time1Picker.date), 
            lunchTime: useDateToGetTime(src: time2Picker.date),
            dinnerTime: useDateToGetTime(src: time3Picker.date),
            bedtimeTime: useDateToGetTime(src: time4Picker.date),
            mealBefore: beforeMeal.integer,
            mealAfter: afterMeal.integer,
            bedtimeBefore: beforeBed.integer)
        SDKManager.sdk.setRoutineTime(reqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            if responseModel.success {
                print("setRoutineTime success!!")
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.requestSetRoutineTime()
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
            
            //ProgressHUD.dismiss()
        }
    }
}
