//
//  EditSingleReminderViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/19.
//

import UIKit
import KeychainSwift
import ProgressHUD

protocol EditSingleReminderViewControllerDelegate: AnyObject {
    func popPanModalSaveSuccessAlert()
    func popPanModalDeleteSuccessAlert()
}

class EditSingleReminderViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    //@IBOutlet weak var medicineNicknameLabel: UILabel!
    @IBOutlet weak var medicineDoseLabel: UILabel!
    @IBOutlet weak var medicineUsageLabel: UILabel!
    @IBOutlet weak var firstSettingView: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var thirdSettingView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    var rspItem: ReminderRspModel?
    var originalReminderDateTime: String = ""
    var currentSettingDate: String = ""
    var currentSettingTime: String = ""
    weak var delegate: EditSingleReminderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        createRightBarButtonViaImage(imageName: "delete_icon_black")
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        "reminderSettingMedicineInfo": {
            "medicineName": "降血壓藥",
            "medicineNameAlias": "降血壓",
            "dose": 1.0,
            "doseUnits": "顆",
            "useTime": "PC"
        }
        */
        
        if let rspItem = self.rspItem {
            originalReminderDateTime = "\(rspItem.reminderDate) \(rspItem.reminderTime)"
            
            startDatePicker.date = DateTimeUtils.convertStringToDate(dateString: rspItem.reminderDate)
            
            medicineNameLabel.text = rspItem.reminderSettingMedicineInfo.medicineName
            //medicineNicknameLabel.text = rspItem.reminderSettingMedicineInfo.medicineNameAlias
            medicineDoseLabel.text = "\(rspItem.reminderSettingMedicineInfo.dose.cleanString)\(rspItem.reminderSettingMedicineInfo.doseUnits)"
            medicineUsageLabel.text = takingTimeCodeMapping[rspItem.reminderSettingMedicineInfo.useTime] ?? "飯後"
            
            updateUIviaRspItemInfo(date: rspItem.reminderDate, time: rspItem.reminderTime)
        }
        
        /*
        medicineNameLabel.translatesAutoresizingMaskIntoConstraints = false
        medicineNameLabel.numberOfLines = 0 // 允許不限行數（最多自動撐到兩行）
        medicineNameLabel.lineBreakMode = .byWordWrapping // 按字元或詞語換行
        medicineNameLabel.setContentHuggingPriority(.required, for: .vertical) // 高度優先度高
        medicineNameLabel.setContentCompressionResistancePriority(.required, for: .vertical) // 不壓縮高度
        */
    }
    
    @objc override func popPresentedViewController() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "是否放棄設定並返回「用藥管理」?"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .none
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func processDeleteAction() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "是否刪除本次用藥提醒?"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .delete_single_reminder
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        processDeleteAction()
    }
    
    @objc override func rightBarButtonTapped() {
        processDeleteAction()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if confirmInputDateIsLegal() {
            // call API
            if let rspItem = self.rspItem {
                if rspItem.reminderSingleTimeSettingId == 0 {
                    createSingleReminderSetting(isRemoved: false)
                } else {
                    updateSingleReminderSetting(isRemoved: false)
                }
            }
            
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

extension EditSingleReminderViewController {
    func updateUI() {
        // 移除所有 subView
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        scrollView.delegate = self
        
        topView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        firstSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        thirdSettingView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        bottomLineView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        topLineView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        resetButtonsUI()
        enableNextButton()
        
        startDatePicker.locale = Locale(identifier: "zh-Hant_TW")
    }
    
    func updateUIviaRspItemInfo(date: String, time: String) {
        self.setItemView(addBottomLine: false, itemIndex: 0, defaultTime: time)
        //scrollView.setContentOffset(CGPoint.zero, animated: false)
        //scrollView.layoutIfNeeded()
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
    
    func confirmInputDateIsLegal() -> Bool {
        if itemListView.arrangedSubviews.count > 0 {
            let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[0] as! TakingTimeSelectView
            let timeStr: String = DateTimeUtils.convertDateToTimeString(srcDate: subViewInStack.timePicker.date, formate: "HH:mm")
            let dateStr: String = DateTimeUtils.convertDateToTimeString(srcDate: self.startDatePicker.date, formate: "yyyy/MM/dd")
            let dateTime: String = "\(dateStr) \(timeStr)"
            
            if DateTimeUtils.convertStringToDate(dateString: dateTime, format: "yyyy/MM/dd HH:mm") >= DateTimeUtils.convertStringToDate(dateString: self.originalReminderDateTime, format: "yyyy/MM/dd HH:mm:ss") {
                return true
            }
        }
        return false
    }
}

extension EditSingleReminderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Note: 讓Scroll不能左右滑
        scrollView.contentOffset.x = 0
    }
}

extension EditSingleReminderViewController {
    func setDefaultTimes(time: String, srcTimePicker: UIDatePicker) {
        let timeWithoutSeconds = String(time.prefix(5))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: timeWithoutSeconds) else {
            fatalError("Unknown Time Format!")
        }
        srcTimePicker.date = date
    }
    
    func setItemView(addBottomLine: Bool, itemIndex: Int, defaultTime: String) {
        let view = TakingTimeSelectView()
        
        view.itemText = "時間"
        view.hasDeleteBtn = false
        view.currentIndex = itemIndex
        // view.delegate = self
        view.timePicker.locale = Locale(identifier: "zh-Hant_TW")
        setDefaultTimes(time: defaultTime, srcTimePicker: view.timePicker)
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
}

extension EditSingleReminderViewController {
    func createSingleReminderSetting(isRemoved: Bool) {
        guard let rspItem = self.rspItem else {
            return
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)

        self.currentSettingDate = DateTimeUtils.convertDateToTimeString(srcDate: self.startDatePicker.date)
        if itemListView.arrangedSubviews.count > 0 {
            let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[0] as! TakingTimeSelectView
            self.currentSettingTime = DateTimeUtils.convertDateToTimeString(srcDate: subViewInStack.timePicker.date, formate: "HH:mm:ss")
        }
        
        let request: CreateSingleReminderSettingModel = CreateSingleReminderSettingModel(isRemoved: isRemoved, originalRemindDate: rspItem.reminderDate, remindDate: self.currentSettingDate, remindTime: self.currentSettingTime, reminderSettingId: rspItem.reminderSettingId, reminderTimeSettingId: rspItem.reminderTimeSettingId)
        SDKManager.sdk.createReminderSingleTimeSetting(request) {
            (responseModel: PhiResponseModel<ReminderSettingIdInfoRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                if isRemoved {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController({
                            self.delegate?.popPanModalDeleteSuccessAlert()
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController({
                            self.delegate?.popPanModalSaveSuccessAlert()
                        })
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.createSingleReminderSetting(isRemoved: isRemoved)
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func updateSingleReminderSetting(isRemoved: Bool) {
        guard let rspItem = self.rspItem else {
            return
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)

        self.currentSettingDate = DateTimeUtils.convertDateToTimeString(srcDate: self.startDatePicker.date)
        if itemListView.arrangedSubviews.count > 0 {
            let subViewInStack: TakingTimeSelectView = itemListView.arrangedSubviews[0] as! TakingTimeSelectView
            self.currentSettingTime = DateTimeUtils.convertDateToTimeString(srcDate: subViewInStack.timePicker.date, formate: "HH:mm:ss")
        }
        
        let request: ModifySingleReminderSettingModel = ModifySingleReminderSettingModel(isRemoved: isRemoved, remindDate: self.currentSettingDate, remindTime: self.currentSettingTime, reminderSettingId: rspItem.reminderSettingId, reminderTimeSettingId: rspItem.reminderTimeSettingId, reminderSingleTimeSettingId: rspItem.reminderSingleTimeSettingId)
        SDKManager.sdk.modifyReminderSingleTimeSetting(request) {
            (responseModel: PhiResponseModel<ReminderSettingIdInfoRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                if isRemoved {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController({
                            self.delegate?.popPanModalDeleteSuccessAlert()
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController({
                            self.delegate?.popPanModalSaveSuccessAlert()
                        })
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.updateSingleReminderSetting(isRemoved: isRemoved)
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}

extension EditSingleReminderViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .delete_single_reminder {
            // call API
            if let rspItem = self.rspItem {
                if rspItem.reminderSingleTimeSettingId == 0 {
                    createSingleReminderSetting(isRemoved: true)
                } else {
                    updateSingleReminderSetting(isRemoved: true)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
