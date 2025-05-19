//
//  SportSettingViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/11/1.
//

import UIKit
import KeychainSwift
import ProgressHUD

protocol SportSettingViewControllerDelegate: AnyObject {
    func popPanModalAddSuccess()
}

class SportSettingViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var sportNameTextField: UITextField!
    @IBOutlet weak var sportFreqTextField: UITextField!
    @IBOutlet weak var showMenuButton: UIButton!
    @IBOutlet weak var daysButtonStackView: UIStackView!
    @IBOutlet weak var sportTimePicker: UIDatePicker!
    @IBOutlet weak var targetEndDatePicker: UIDatePicker!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentSettingDate: String = ""
    var currentSettingTime: String = ""
    weak var delegate: SportSettingViewControllerDelegate?
    // Selected days storage
    var selectedDays: Set<Int> = []
    // Repeat option state
    var selectedRepeatOption: String = "不重複" // 初始值為「不重複」
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if confirmInputDateIsLegal() {
            // call API
            let selectedDaysArray = Array(selectedDays).sorted()
            // Prepare data for API
            let payload: [String: Any] = ["selectedDays": selectedDaysArray]
            
        } else {
            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
            //alertViewController.delegate = self
            alertViewController.alertLabel.text = "設定提醒時間不能早於現在時間"
            alertViewController.alertImageView.image = UIImage(named: "Error")
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension SportSettingViewController {
    func updateUI() {
        scrollView.delegate = self
        firstBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        secondBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        showMenuButton.showsMenuAsPrimaryAction = true
        // Update menu whenever the button is tapped
        updateRepeatMenu()
        
        // Configure the StackView for the day buttons
        daysButtonStackView.axis = .horizontal
        daysButtonStackView.alignment = .center
        // This will make sure spaces between buttons are equal
        daysButtonStackView.distribution = .equalSpacing
        daysButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        // Day Buttons (Sunday to Saturday)
        let days = ["日", "一", "二", "三", "四", "五", "六"]
        //let selectedButtonColor = UIColor(hex: "#3399DB", alpha: 1.0) // #3399DB
        let unselectedTitleColor = UIColor(hex: "#434A4E", alpha: 1.0) // #434A4E
        
        for (index, day) in days.enumerated() {
            let button = UIButton(type: .system)
            button.tag = index // Sunday=0, Monday=1, ..., Saturday=6
            button.setTitle(day, for: .normal)
            button.setTitleColor(unselectedTitleColor, for: .normal)
            button.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 14) // 指定字型
            button.layer.cornerRadius = 14 // Half of 28 to make it a circle
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.clear.cgColor
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // Set fixed size for button to ensure it remains circular
            button.widthAnchor.constraint(equalToConstant: 28).isActive = true
            button.heightAnchor.constraint(equalToConstant: 28).isActive = true
            
            daysButtonStackView.addArrangedSubview(button)
        }
        
        sportTimePicker.locale = Locale(identifier: "zh-Hant_TW")
        targetEndDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        resetButtonsUI()
        enableNextButton()
    }
    
    func resetButtonsUI() {
        /*
         deleteButton.isEnabled = true
         deleteButton.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
         deleteButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
         deleteButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
         deleteButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
         deleteButton.layer.borderWidth = 1.0
         */
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.borderWidth = 1.0
        saveButton.setTitle("確定新增", for: .normal)
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
    
    func confirmInputDateIsLegal() -> Bool {
        let timeStr: String = DateTimeUtils.convertDateToTimeString(srcDate: sportTimePicker.date, formate: "HH:mm")
        let dateStr: String = DateTimeUtils.convertDateToTimeString(srcDate: targetEndDatePicker.date, formate: "yyyy/MM/dd")
        let dateTime: String = "\(dateStr) \(timeStr)"
        
        if DateTimeUtils.convertStringToDate(dateString: dateTime, format: "yyyy/MM/dd HH:mm") >= Date() {
            return true
        }
        return false
    }
    
    func updateRepeatMenu() {
        let options = ["不重複", "每天", "每週", "每兩週"]
        var menuActions: [UIAction] = []
        
        for option in options {
            let action = UIAction(
                title: option,
                state: option == selectedRepeatOption ? .on : .off, // 預設勾選上次選項
                handler: { [weak self] _ in
                    self?.handleRepeatSelection(option: option)
                }
            )
            menuActions.append(action)
        }
        
        showMenuButton.menu = UIMenu(title: "", children: menuActions)
    }
    
    func handleRepeatSelection(option: String) {
        sportFreqTextField.text = option
        selectedRepeatOption = option // 更新選中的選項
        updateRepeatMenu() // 更新菜單中的勾選狀態
        
        if option == "每天" {
            lockDayButtons()
        } else {
            unlockDayButtons(keepSelected: true) // 保持已選中按鈕狀態
        }
    }
    
    func unlockDayButtons(keepSelected: Bool) {
        let selectedButtonColor = UIColor(hex: "#3399DB", alpha: 1.0)!
        let unselectedTitleColor = UIColor(hex: "#434A4E", alpha: 1.0)!
        
        for case let button as UIButton in daysButtonStackView.arrangedSubviews {
            button.isUserInteractionEnabled = true
            
            if keepSelected, selectedDays.contains(button.tag) {
                // 如果已選擇且要保留選擇狀態
                button.backgroundColor = selectedButtonColor
                button.layer.borderColor = selectedButtonColor.cgColor
                button.setTitleColor(.white, for: .normal)
            } else {
                // 還原未選擇狀態
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.clear.cgColor
                button.setTitleColor(unselectedTitleColor, for: .normal)
            }
        }
    }
    
    func lockDayButtons() {
        let lockedButtonColor = UIColor(hex: "#989898", alpha: 1.0)!
        
        for case let button as UIButton in daysButtonStackView.arrangedSubviews {
            button.isUserInteractionEnabled = false
            button.backgroundColor = lockedButtonColor
            button.layer.borderColor = lockedButtonColor.cgColor
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    func unlockDayButtons() {
        let unselectedTitleColor = UIColor(hex: "#434A4E", alpha: 1.0)!
        
        for case let button as UIButton in daysButtonStackView.arrangedSubviews {
            button.isUserInteractionEnabled = true
            button.backgroundColor = .clear
            button.layer.borderColor = UIColor.clear.cgColor
            button.setTitleColor(unselectedTitleColor, for: .normal)
        }
    }
    
    @objc func dayButtonTapped(_ sender: UIButton) {
        let selectedButtonColor = UIColor(hex: "#3399DB", alpha: 1.0)!
        let unselectedTitleColor = UIColor(hex: "#434A4E", alpha: 1.0)!
        
        if selectedDays.contains(sender.tag) {
            // Deselect
            selectedDays.remove(sender.tag)
            sender.backgroundColor = .clear
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.setTitleColor(unselectedTitleColor, for: .normal)
        } else {
            // Select
            selectedDays.insert(sender.tag)
            sender.backgroundColor = selectedButtonColor
            sender.layer.borderColor = selectedButtonColor.cgColor
            sender.setTitleColor(.white, for: .normal)
        }
    }
}

extension SportSettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}
