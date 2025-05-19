//
//  WorkRestTimeSettingVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/11.
//

import UIKit

protocol WorkRestTimeSettingVCDelegate: AnyObject {
    func presentNextSettingView()
}

class WorkRestTimeSettingVC: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var thirdSettingView: UIView!
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
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: WorkRestTimeSettingVCDelegate?
    
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
            //
        }
    }
    
    func useDateToGetTime(src: Date) -> String {
        let selectedTime = src
        
        // 將時間轉換成字串
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh-Hant_TW")
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: selectedTime)
        
        print(timeString)
        return timeString
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
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        saveTimeToUserDefaults()
        
        self.dismiss(animated: true) {
            self.delegate?.presentNextSettingView()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension WorkRestTimeSettingVC {
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
    
    func updateUI() {
        scrollView.delegate = self
        
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        
        thirdSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        resetButtonsUI()
        enableNextButton()
        
        updateTimePickersUI()
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

extension WorkRestTimeSettingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}
