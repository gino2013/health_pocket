//
//  ReminderTimeSettingVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/11.
//

import UIKit

protocol ReminderTimeSettingVCDelegate: AnyObject {
    func presentWorkRestTimeSettingView()
    func presentSettingFinishView()
}

class ReminderTimeSettingVC: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var thirdSettingView: UIView!
    @IBOutlet weak var timeOneView: UIView!
    @IBOutlet weak var lineOneView: UIView!
    @IBOutlet weak var timeTwoView: UIView!
    @IBOutlet weak var lineTwoView: UIView!
    @IBOutlet weak var timeThreeView: UIView!
    
    @IBOutlet weak var beforeMealTextField: UITextField!
    @IBOutlet weak var afterMealTextField: UITextField!
    @IBOutlet weak var beforeBedTextField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // let minutes = Array(0...59)
    // 修改後的分鐘數組，每5分鐘一個選擇
    let minutes = Array(stride(from: 0, to: 60, by: 5))
    var activeTextField: UITextField?
    var pickerView: UIPickerView!
    weak var delegate: ReminderTimeSettingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.126) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .clear
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.presentWorkRestTimeSettingView()
        }
    }
    
    func saveMinuteSettingToUserDefaults() {
        if let beforeMeal = beforeMealTextField.text,
           let afterMeal = afterMealTextField.text,
           let beforeBed = beforeBedTextField.text {
            let settingInfo: ReminderTimeSetting = ReminderTimeSetting(beforeMeal: beforeMeal.integer, afterMeal: afterMeal.integer, beforeBed: beforeBed.integer)
            
            UserDefaults.standard.saveReminderTimeSetting(settingInfo)
        }
    }
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        saveMinuteSettingToUserDefaults()
        
        self.dismiss(animated: true) {
            self.delegate?.presentSettingFinishView()
        }
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    */
}

extension ReminderTimeSettingVC {
    func updateUI() {
        scrollView.delegate = self
        
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        
        thirdSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        resetButtonsUI()
        enableNextButton()
        
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
        nextButton.setTitle("下一步", for: .normal)
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
    
    func convertTimeToTimeString(srcPicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.string(from: srcPicker.date)
        
        return selectedTime
    }
}

extension ReminderTimeSettingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension ReminderTimeSettingVC: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
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
    
    // 完成按鈕的操作
    @objc func doneTapped() {
        activeTextField?.resignFirstResponder()
    }
}
