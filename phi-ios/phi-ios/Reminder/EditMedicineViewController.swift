//
//  EditMedicineViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/8.
//

import UIKit
import KeychainSwift
import ProgressHUD

protocol EditMedicineViewControllerDelegate: AnyObject {
    func clickSaveBtn(medicineAlias: String, prescriptionCode: String)
    func editReminderClickSaveBtn(medicineAlias: [String], reminderIndex: String)
}

class EditMedicineViewController: BaseViewController {
    
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var MedInfoEditItem1: MedItemTextFieldView!
    @IBOutlet weak var MedInfoEditItem2: MedItemTextFieldView!
    @IBOutlet weak var MedInfoEditItem3: MedItemTextFieldView!
    @IBOutlet weak var MedInfoEditItem4: MedItemTextFieldView!
    @IBOutlet weak var MedInfoEditItem5: MedItemTextFieldView!
    
    //var selectMedicineInfo: PrescriptionInfo?
    var currentSelectItems: [AddReminderCellViewModel] = []
    var currentMedicineInfo: [MedicineInfo] = []
    weak var delegate: EditMedicineViewControllerDelegate?
    var medicineAlias: String = ""
    var currentPrescriptionCode: String = ""
    var editReminderMode: Bool = false
    var currentReminderItemIndex: String = ""
    var currentUsagetimeDesc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        
        // checkmarx
        //MedInfoEditItem2.medInfoTextField.delegate = self
        
        if currentSelectItems.count > 0 {
            let prescriptionInfo: PrescriptionInfo = currentSelectItems[0].cellInfo
            self.currentPrescriptionCode = prescriptionInfo.prescriptionCode
            updateUI(fromSrvRsp: prescriptionInfo)
        } else if currentMedicineInfo.count > 0 {
            let mInfo: MedicineInfo = currentMedicineInfo[0]
            
            MedInfoEditItem1.infoText = mInfo.medicineName
            MedInfoEditItem1.addBottomLine = true
            MedInfoEditItem1.medInfoTextField.borderStyle = .none
            MedInfoEditItem1.medInfoTextField.isUserInteractionEnabled = false
            MedInfoEditItem1.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
            
            MedInfoEditItem2.infoText = mInfo.medicineNameAlias
            MedInfoEditItem2.addBottomLine = true
            MedInfoEditItem2.medInfoTextField.borderStyle = .none
            
            MedInfoEditItem3.infoText = "\(mInfo.dose)\(mInfo.doseUnits)"
            MedInfoEditItem3.addBottomLine = true
            MedInfoEditItem3.medInfoTextField.borderStyle = .none
            MedInfoEditItem3.medInfoTextField.isUserInteractionEnabled = false
            MedInfoEditItem3.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
            
            MedInfoEditItem4.infoText = self.currentUsagetimeDesc
            MedInfoEditItem4.addBottomLine = true
            MedInfoEditItem4.medInfoTextField.borderStyle = .none
            MedInfoEditItem4.medInfoTextField.isUserInteractionEnabled = false
            MedInfoEditItem4.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
            
            MedInfoEditItem5.infoText = takingTimeCodeMapping[mInfo.useTime] ?? "飯後"
            MedInfoEditItem5.addBottomLine = false
            MedInfoEditItem5.medInfoTextField.borderStyle = .none
            MedInfoEditItem5.medInfoTextField.isUserInteractionEnabled = false
            MedInfoEditItem5.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
        }
        
        // 綁定 MedInfoEditItem2.medInfoTextField 當編輯結束時觸發
        MedInfoEditItem2.medInfoTextField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    // checkmarx
    @objc func processEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            medicineAlias = text
            
            if text.isEmpty {
                saveButton.isEnabled = false
                saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                saveButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
            } else {
                saveButton.isEnabled = true
                saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
                saveButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            }
        }
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
    
    func updateUI(fromSrvRsp: PrescriptionInfo) {
        MedInfoEditItem1.infoText = fromSrvRsp.medicineName
        MedInfoEditItem1.addBottomLine = true
        MedInfoEditItem1.medInfoTextField.borderStyle = .none
        MedInfoEditItem1.medInfoTextField.isUserInteractionEnabled = false
        MedInfoEditItem1.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
        
        MedInfoEditItem2.infoText = fromSrvRsp.medicineAlias
        MedInfoEditItem2.addBottomLine = true
        MedInfoEditItem2.medInfoTextField.borderStyle = .none
        
        MedInfoEditItem3.infoText = "\(fromSrvRsp.dose)\(fromSrvRsp.doseUnits)"
        MedInfoEditItem3.addBottomLine = true
        MedInfoEditItem3.medInfoTextField.borderStyle = .none
        MedInfoEditItem3.medInfoTextField.isUserInteractionEnabled = false
        MedInfoEditItem3.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
        
        MedInfoEditItem4.infoText = fromSrvRsp.usagetimeDesc
        MedInfoEditItem4.addBottomLine = true
        MedInfoEditItem4.medInfoTextField.borderStyle = .none
        MedInfoEditItem4.medInfoTextField.isUserInteractionEnabled = false
        MedInfoEditItem4.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
        
        MedInfoEditItem5.infoText = fromSrvRsp.takingTime
        MedInfoEditItem5.addBottomLine = false
        MedInfoEditItem5.medInfoTextField.borderStyle = .none
        MedInfoEditItem5.medInfoTextField.isUserInteractionEnabled = false
        MedInfoEditItem5.medInfoTextField.textColor = UIColor(hex: "#434A4E", alpha: 1)
    }
    
    func updateUI() {
        itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //buttonContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        resetButtonsUI()
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
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController({
            if self.editReminderMode {
                self.delegate?.editReminderClickSaveBtn(medicineAlias: [self.medicineAlias], reminderIndex: self.currentReminderItemIndex)
            } else {
                self.delegate?.clickSaveBtn(medicineAlias: self.medicineAlias,
                                            prescriptionCode: self.currentPrescriptionCode)
            }
        })
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

extension EditMedicineViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        self.navigationController?.popViewController(animated: true)
    }
}
