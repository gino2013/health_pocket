//
//  MedicineTakingSettingVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/31.
//

import UIKit

protocol MedicineTakingSettingVCDelegate: AnyObject {
    func processReminderRecordMedicineInfo(isChecked: Bool,
                                           reminderInfo: ReminderRspModel,
                                           checkTime: String,
                                           section: Int,
                                           row: Int)
}

class MedicineTakingSettingVC: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var takingTimeLabel: UILabel!
    //@IBOutlet weak var medicineAliasLabel: UILabel!
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var doneTimeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var rspItem: ReminderRspModel?
    weak var delegate: MedicineTakingSettingVCDelegate?
    var currentIsCheck: Bool = false
    var currentReminderInfo: ReminderRspModel?
    var currentCheckTime: String = ""
    var currentSectionExtsSection: Int = 0
    var currentSectionExtsRow: Int = 0
    
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
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let currentReminderInfo = self.currentReminderInfo {
                self.delegate?.processReminderRecordMedicineInfo(isChecked: self.currentIsCheck, reminderInfo: currentReminderInfo, checkTime: self.currentCheckTime, section: self.currentSectionExtsSection, row: self.currentSectionExtsRow)
            }
        }
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    */
}

extension MedicineTakingSettingVC {
    func updateUI() {
        scrollView.delegate = self
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        //baseView.layer.cornerRadius = 12
        //baseView.layer.borderWidth = 1
        //baseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
        
        baseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        secondBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        if let rspItem = self.rspItem {
            titleLabel.text = rspItem.reminderSettingMedicineInfo.medicineName
            //medicineAliasLabel.text = rspItem.reminderSettingMedicineInfo.medicineNameAlias
            doseLabel.text = "\(rspItem.reminderSettingMedicineInfo.dose.cleanString)\(rspItem.reminderSettingMedicineInfo.doseUnits)"
            takingTimeLabel.text = takingTimeCodeMapping[rspItem.reminderSettingMedicineInfo.useTime] ?? "飯後"
            
            if rspItem.checkTime.isEmpty {
                let dateTimeFormatter = DateFormatter()
                dateTimeFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
              
                self.currentCheckTime = dateTimeFormatter.string(from: Date())
                doneTimeLabel.text = String(self.currentCheckTime.prefix(16))
            } else {
                doneTimeLabel.text = String(rspItem.checkTime.prefix(16))
            }
            
            resetButtonsUI(isChecked: rspItem.isChecked)
            
            self.currentIsCheck = rspItem.isChecked
            self.currentReminderInfo = rspItem
        }
    
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        bottomView.addTopShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))

        enableNextButton()
    }
    
    func resetButtonsUI(isChecked: Bool) {
        cancelButton.isEnabled = true
        cancelButton.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        cancelButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
        cancelButton.layer.borderWidth = 1.0
        
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        nextButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.layer.borderWidth = 1.0
        if isChecked {
            nextButton.setTitle("未服用", for: .normal)
        } else {
            nextButton.setTitle("服用了", for: .normal)
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
}

extension MedicineTakingSettingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}
