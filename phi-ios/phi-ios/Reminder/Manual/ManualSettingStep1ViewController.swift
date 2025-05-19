//
//  ManualSettingStep1ViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/19.
//

import UIKit
import KeychainSwift
import ProgressHUD

class ManualSettingStep1ViewController: BaseViewController {
    
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var stepUIView: UIView!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var addMedicineButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentUnit: String = ""
    var currentUsage: String = ""
    var currentUsageTime: Int = 1
    var currentTakingTime: String = ""
    var currentTakingTimeCode: String = ""
    weak var delegate_MedicationManagementVC: ManualSettingStep2ViewControllerDelegate?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    deinit {
        // NotificationCenter.default.removeObserver(self)
    }
   
    // checkmarx
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
    }
    
    // checkmarx
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func updateUI() {
        parentScrollView.delegate = self
        
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        //buttonContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        resetButtonsUI()
        
        //let item = MedicationReminder(reminderId: "1212", medicationNames: ["停敏膜衣锭", "止痛药"], medicationIds: [1,2], frequencyType: .daily, times: ["08:30", "12:30", "18:30"], period: "2023/07/16-2023/08/16")
        self.setItemView(addBottomLine: false, itemIndex: 0)
    }
    
    func resetButtonsUI() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
        nextButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.layer.borderWidth = 1.0
        nextButton.setTitle("下一步", for: .normal)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        // If only 1 medicine -> Fast setting reminder flow
        if SharingManager.sharedInstance.currManualPrescriptionInfos.count == 1 {
            let storyboard = UIStoryboard(name: "ManualSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ManualSettingStep2ViewController") as! ManualSettingStep2ViewController

            vc.delegate = self.delegate_MedicationManagementVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // If > 1 medicine -> normal setting remonder flow
            let storyboard = UIStoryboard(name: "Reminder", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedReminderViewController") as! MedReminderViewController
            // Need check data: SharingManager.sharedInstance.currAutoImportPrescriptionInfos
            SharingManager.sharedInstance.currAutoImportPrescriptionInfos = SharingManager.sharedInstance.currManualPrescriptionInfos
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc override func popPresentedViewController() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "是否放棄編輯並返回?"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .firstAuthorization
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func addMedicineAction(_ sender: UIButton) {
        //let item = MedicationReminder(reminderId: "1212", medicationNames: ["停敏膜衣锭", "止痛药"], medicationIds: [1,2], frequencyType: .daily, times: ["08:30", "12:30", "18:30"], period: "2023/07/16-2023/08/16")
        // 獲取當前已添加的View數量
        let viewCount = itemListView.arrangedSubviews.count
        self.setItemView(addBottomLine: false, itemIndex: viewCount)
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
    }
}

extension ManualSettingStep1ViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ManualSettingStep1ViewController {
    func setItemView(addBottomLine: Bool, itemIndex: Int) {
        let view = ReminderSettingStep1View()
        
        view.titleText = "藥品"
        view.currentIndex = itemIndex
        view.addviewShadow = true
        view.delegate = self
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 430.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: ReminderSettingStep1View) {
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
        if let viewToRemove = self.itemListView.arrangedSubviews.first(where: { ($0 as? ReminderSettingStep1View)?.currentIndex == index }) {
            UIView.animate(withDuration: 0.3, animations: {
                viewToRemove.isHidden = true
                viewToRemove.removeFromSuperview()
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updateUnitTextField(viewWithIndex index: Int, text: String) {
        if let viewToUpdate: ReminderSettingStep1View = self.itemListView.arrangedSubviews.first(where: { ($0 as? ReminderSettingStep1View)?.currentIndex == index }) as? ReminderSettingStep1View {
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.unitText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updateUsageTextField(viewWithIndex index: Int, text: String, usageTime: Int) {
        if let viewToUpdate: ReminderSettingStep1View = self.itemListView.arrangedSubviews.first(where: { ($0 as? ReminderSettingStep1View)?.currentIndex == index }) as? ReminderSettingStep1View {
            
            viewToUpdate.usageTime = usageTime
            
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.usageText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updateTakingTimeTextField(viewWithIndex index: Int, text: String) {
        if let viewToUpdate: ReminderSettingStep1View = self.itemListView.arrangedSubviews.first(where: { ($0 as? ReminderSettingStep1View)?.currentIndex == index }) as? ReminderSettingStep1View {
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.takingTimeText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ManualSettingStep1ViewController: ReminderSettingStep1ViewDelegate {
    func clickDeleteBtn(itemIndex: Int) {
        // 獲取當前已添加的View數量
        let viewCount = itemListView.arrangedSubviews.count
        
        if viewCount > 1 {
            self.onRemove(viewWithIndex: itemIndex)
            self.textFieldDidChange()
        } else  {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "必須保留一個藥品"
            alertViewController.isKeyButtonLeft = true
            alertViewController.confirmButton.setTitle("我知道了", for: .normal)
            alertViewController.cancelButton.isHidden = true
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showUnitSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectUnit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectUnitViewController") as! SelectUnitViewController
        vc.onSaveUnit = { (unit: String) -> () in
            self.currentUnit = unit
            
            DispatchQueue.main.async { [self] in
                self.updateUnitTextField(viewWithIndex: itemIndex, text: self.currentUnit)
                self.textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func showUsageSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectUsage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectUsageViewController") as! SelectUsageViewController
        vc.onSaveUsage = { (usage: String, usageTime: Int) -> () in
            self.currentUsage = usage
            self.currentUsageTime = usageTime
            
            DispatchQueue.main.async { [self] in
                self.updateUsageTextField(viewWithIndex: itemIndex, text: self.currentUsage, usageTime: self.currentUsageTime)
                self.textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func showTakingTimeSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectTakingTime", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectTakingTimeVC") as! SelectTakingTimeVC
        vc.onSaveTakingTime = { (takingTime: String) -> () in
            self.currentTakingTime = takingTime
            self.currentTakingTimeCode = takingTimeTypeMapping[self.currentTakingTime] ?? "PC"
            
            DispatchQueue.main.async { [self] in
                self.updateTakingTimeTextField(viewWithIndex: itemIndex, text: self.currentTakingTime)
                self.textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func saveAllInputThenCreateModel() -> [PrescriptionInfo] {
        /*
        PrescriptionInfo(medicineName: "停敏膜衣錠", medicineAlias: "待設定", useDays: "1", usagetimeDesc: "每日三次", takingTime: "飯後", prescriptionCode: "1A2B", usagetime: 3),
        */
        
        var prescriptionInfos = [PrescriptionInfo]()
        
        // AC("飯前"), PC("飯後"), HS("睡前"), PCHS("飯後、睡前"), ACHS("飯前、睡前"), OTHER("其他時段");
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? ReminderSettingStep1View {
                let medicineName = itemView.drugNameTextField.text ?? ""
                let medicineAlias = itemView.drugAliasTextField.text ?? ""
                let useDays = itemView.perDoseTextField.text ?? ""
                let unit = itemView.unitTextField.text ?? ""
                let usagetimeDesc = itemView.usageTextField.text ?? ""
                let takingTime = itemView.takingTimeTextField.text ?? ""
                
                let frequencyTimes = usageDictMapping[usagetimeDesc] ?? 1
                let prescriptionCode = "\(frequencyTimes)\(takingTime)"

                let info = PrescriptionInfo(medicineName: medicineName, medicineAlias: medicineAlias, dose: useDays.integer, doseUnits: unit, useTime: takingTimeTypeMapping[takingTime] ?? "AC", usagetimeDesc: usagetimeDesc, takingTime: takingTime, prescriptionCode: prescriptionCode, frequencyTimes: frequencyTimes)
                
                prescriptionInfos.append(info)
            }
        }
        
        return prescriptionInfos
    }
    
    func textFieldDidChange() {
        // 檢查所有 RSettingStep1View 的 UITextField 是否有值
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? ReminderSettingStep1View {
                if itemView.drugNameTextField.text?.isEmpty ?? true ||
                    // itemView.drugAliasTextField.text?.isEmpty ?? true ||
                    itemView.perDoseTextField.text?.isEmpty ?? true ||
                    itemView.unitTextField.text?.isEmpty ?? true ||
                    itemView.usageTextField.text?.isEmpty ?? true ||
                    itemView.takingTimeTextField.text?.isEmpty ?? true {
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    nextButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
                    return
                }
            }
        }
        
        // create data structure for step2
        SharingManager.sharedInstance.currManualPrescriptionInfos = saveAllInputThenCreateModel()
        
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        nextButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
    }
}

extension ManualSettingStep1ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
