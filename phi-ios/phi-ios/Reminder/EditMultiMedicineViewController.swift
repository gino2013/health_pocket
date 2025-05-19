//
//  EditMultiMedicineViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/8.
//

import UIKit
import KeychainSwift
import ProgressHUD

protocol EditMultiMedicineViewControllerDelegate: AnyObject {
    func editMultiClickSaveBtn(medicineAlias: [String], reminderIndex: String)
    func editMultiClickSaveBtn(medicineInfoUpdates: [(dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String)], reminderIndex: String)
}

extension EditMultiMedicineViewControllerDelegate {
    func editMultiClickSaveBtn(medicineAlias: [String], reminderIndex: String) {}
    func editMultiClickSaveBtn(medicineInfoUpdates: [(dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String)], reminderIndex: String) {}
}

class EditMultiMedicineViewController: BaseViewController {
    
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var saveButton: UIButton!

    // var currentSelectItems: [AddReminderCellViewModel] = []
    var currentMedicineInfo: [MedicineInfo] = []
    weak var delegate: EditMultiMedicineViewControllerDelegate?
    var currentMedicineAlias: [String] = []
    var currentReminderItemIndex: String = ""
    var currentUsagetimeDesc: String = ""
    
    var currentUnit: String = ""
    var currentUsage: String = ""
    var currentUsageTime: Int = 1
    var currentTakingTime: String = ""
    var currentTakingTimeCode: String = ""
    var currentManualSettingInfo: [(dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI(fromSrvRsp: currentMedicineInfo)
    }
    
    func updateUI(fromSrvRsp: [MedicineInfo]) {
        for i in 0 ..< fromSrvRsp.count {
            let cellViewItem: MedicineInfo = fromSrvRsp[i]
            //let presInfo: PrescriptionInfo = cellViewItem.cellInfo
            
            if SharingManager.sharedInstance.currentSetReminderMode == .auto {
                setItemView(addBottomLine: false, itemIndex: i, medicineInfo: cellViewItem, usagetimeDesc: self.currentUsagetimeDesc)
            } else if SharingManager.sharedInstance.currentSetReminderMode == .manual {
                setMamuaItemView(addBottomLine: false, itemIndex: i, medicineInfo: cellViewItem, usagetimeDesc: self.currentUsagetimeDesc, numOfItem: fromSrvRsp.count)
            }
        }
    }
    
    func updateUI() {
        parentScrollView.delegate = self
        
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        buttonContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        resetButtonsUI()
        enableNextButton()
    }
    
    func resetButtonsUI() {
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
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if SharingManager.sharedInstance.currentSetReminderMode == .auto {
            self.navigationController?.popViewController({
                self.delegate?.editMultiClickSaveBtn(medicineAlias: self.currentMedicineAlias, reminderIndex: self.currentReminderItemIndex)
            })
        } else if SharingManager.sharedInstance.currentSetReminderMode == .manual {
            manualReminderSaveAllInputInfo()
            
            self.navigationController?.popViewController({
                self.delegate?.editMultiClickSaveBtn(medicineInfoUpdates: self.currentManualSettingInfo, reminderIndex: self.currentReminderItemIndex)
            })
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
}

extension EditMultiMedicineViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditMultiMedicineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension EditMultiMedicineViewController: MedicineSettingViewDelegate {
    func setItemView(addBottomLine: Bool,
                     itemIndex: Int,
                     medicineInfo: MedicineInfo,
                     usagetimeDesc: String) {
        let view = MedicineSettingView()
        
        view.titleText = "藥品"
        view.currentIndex = itemIndex
        view.drugNameText = medicineInfo.medicineName
        view.drugAliasText = medicineInfo.medicineNameAlias
        view.perDoseText = "\(medicineInfo.dose)\(medicineInfo.doseUnits)"
        view.usageText = usagetimeDesc
        view.takingTimeText = takingTimeCodeMapping[medicineInfo.useTime] ?? "飯後"
        view.addviewShadow = true
        view.delegate = self
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 430.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    func textFieldDidChange() {
        // 檢查所有 RSettingStep1View 的 UITextField 是否有值
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? MedicineSettingView {
                if itemView.drugAliasTextField.text?.isEmpty ?? true {
                    saveButton.isEnabled = false
                    saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
                    return
                }
            }
        }
        
        saveAllInputData()
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        saveButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
    }
    
    func saveAllInputData() {
        self.currentMedicineAlias.removeAll()
        
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? MedicineSettingView {
                let medicineAlias = itemView.drugAliasTextField.text ?? ""
                
                self.currentMedicineAlias.append(medicineAlias)
            }
        }
    }
}

extension EditMultiMedicineViewController: EditManualSettingViewDelegate {
    func updateUnitTextField(viewWithIndex index: Int, text: String) {
        if let viewToUpdate: EditManualSettingView = self.itemListView.arrangedSubviews.first(where: { ($0 as? EditManualSettingView)?.currentIndex == index }) as? EditManualSettingView {
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.unitText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updateUsageTextField(viewWithIndex index: Int, text: String, usageTime: Int) {
        if let viewToUpdate: EditManualSettingView = self.itemListView.arrangedSubviews.first(where: { ($0 as? EditManualSettingView)?.currentIndex == index }) as? EditManualSettingView {
            
            viewToUpdate.usageTime = usageTime
            
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.usageText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updateTakingTimeTextField(viewWithIndex index: Int, text: String) {
        if let viewToUpdate: EditManualSettingView = self.itemListView.arrangedSubviews.first(where: { ($0 as? EditManualSettingView)?.currentIndex == index }) as? EditManualSettingView {
            UIView.animate(withDuration: 0.3, animations: {
                viewToUpdate.takingTimeText = text
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setMamuaItemView(addBottomLine: Bool,
                          itemIndex: Int,
                          medicineInfo: MedicineInfo,
                          usagetimeDesc: String,
                          numOfItem: Int = 1) {
        let view = EditManualSettingView()
        
        view.titleText = "藥品"
        view.currentIndex = itemIndex
        view.drugNameTextField.text = medicineInfo.medicineName
        view.drugAliasTextField.text = medicineInfo.medicineNameAlias
        view.perDoseTextField.text = "\(medicineInfo.dose)"
        view.unitTextField.text = medicineInfo.doseUnits
        view.usageTextField.text = usagetimeDesc
        view.takingTimeTextField.text = takingTimeCodeMapping[medicineInfo.useTime] ?? "飯後"
        view.addviewShadow = true
        view.delegate = self
        
        if numOfItem == 1 {
            view.titleLabel.isHidden = true
            /*
            view.usageTextField.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
            view.usageTextField.isUserInteractionEnabled = true
            view.usageButton.isHidden = false
            view.takingTimeTextField.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
            view.takingTimeTextField.isUserInteractionEnabled = true
            view.takingTimeButton.isHidden = false
            */
            view.takingTimeRedStarLabel.isHidden = false
        }
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 370.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    func editManual_showUnitSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectUnit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectUnitViewController") as! SelectUnitViewController
        vc.onSaveUnit = { (unit: String) -> () in
            self.currentUnit = unit
            
            DispatchQueue.main.async { [self] in
                self.updateUnitTextField(viewWithIndex: itemIndex, text: self.currentUnit)
                self.editManual_textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func editManual_showUsageSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectUsage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectUsageViewController") as! SelectUsageViewController
        vc.onSaveUsage = { (usage: String, usageTime: Int) -> () in
            self.currentUsage = usage
            self.currentUsageTime = usageTime
            
            DispatchQueue.main.async { [self] in
                self.updateUsageTextField(viewWithIndex: itemIndex, text: self.currentUsage, usageTime: self.currentUsageTime)
                self.editManual_textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func editManual_showTakingTimeSelectView(itemIndex: Int) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectTakingTime", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectTakingTimeVC") as! SelectTakingTimeVC
        vc.onSaveTakingTime = { (takingTime: String) -> () in
            self.currentTakingTime = takingTime
            self.currentTakingTimeCode = takingTimeTypeMapping[self.currentTakingTime] ?? "PC"
            
            DispatchQueue.main.async { [self] in
                self.updateTakingTimeTextField(viewWithIndex: itemIndex, text: self.currentTakingTime)
                self.editManual_textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    func manualReminderSaveAllInputInfo() {
        self.currentManualSettingInfo.removeAll()
        
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? EditManualSettingView {
                let medicineName = itemView.drugNameTextField.text ?? ""
                let medicineAlias = itemView.drugAliasTextField.text ?? ""
                let perDose = itemView.perDoseTextField.text ?? ""
                let unit = itemView.unitTextField.text ?? ""
                let usage = itemView.usageTextField.text ?? ""
                let takingTime = itemView.takingTimeTextField.text ?? ""
                
                let info: (dose: Int, doseUnits: String, medicineName: String, medicineNameAlias: String, usage: String, takingTime: String) = (perDose.integer, unit, medicineName, medicineAlias, usage, takingTimeTypeMapping[takingTime] ?? "AC")
                self.currentManualSettingInfo.append(info)
            }
        }
    }
    
    func editManual_textFieldDidChange() {
        // 檢查所有 RSettingStep1View 的 UITextField 是否有值
        for subview in itemListView.arrangedSubviews {
            if let itemView = subview as? EditManualSettingView {
                if itemView.drugNameTextField.text?.isEmpty ?? true ||
                    //itemView.drugAliasTextField.text?.isEmpty ?? true ||
                    itemView.perDoseTextField.text?.isEmpty ?? true ||
                    itemView.unitTextField.text?.isEmpty ?? true ||
                    itemView.usageTextField.text?.isEmpty ?? true ||
                    itemView.takingTimeTextField.text?.isEmpty ?? true {
                    saveButton.isEnabled = false
                    saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
                    return
                }
            }
        }
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        saveButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
    }
}
