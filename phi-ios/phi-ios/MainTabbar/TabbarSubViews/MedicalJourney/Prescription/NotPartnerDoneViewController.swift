//
//  NotPartnerDoneViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/20.
//

import UIKit
import ProgressHUD

class NotPartnerDoneViewController: BaseViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medAddressLabel: UILabel!
    @IBOutlet weak var medPhoneLabel: UILabel!
    
    @IBOutlet var businessHoursLabelArray: [UILabel]!
    
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var retryExecuted: Bool = false
    var isReceiveMedicineFinish: Bool = false
    var currentSelectedItem: PharmacyCellViewModel?
    var receiveRecordIdFromSrv: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        showNoticeAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    func updateUI() {
        baseView.layer.cornerRadius = 8
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
        
        if let currentSelectedItem = self.currentSelectedItem {
            title = currentSelectedItem.hospitalName
            medNameLabel.text = currentSelectedItem.hospitalName
            medAddressLabel.text = currentSelectedItem.address
            medPhoneLabel.text = currentSelectedItem.contactPhone
            
            /*
            for (index, label) in businessHoursLabelArray.enumerated() {
                label.text = currentSelectedItem.businessHours[index]
            }
            */
            
            for (index, time) in currentSelectedItem.businessHours.enumerated() {
                businessHoursLabelArray[index].text = time
            }
        }
    }
    
    func showNoticeAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "該藥局無法進行預約或掃碼領藥，僅能建立領藥紀錄，可直接洽詢該藥局或是更換藥局"
        alertViewController.isKeyButtonLeft = true
        alertViewController.confirmButton.setTitle("我知道了", for: .normal)
        alertViewController.cancelButton.isHidden = true
        alertViewController.alertType = .none
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func openMapAction(_ sender: UIButton) {
        let actionSheet = UIAlertController()
        let action1 = UIAlertAction(title: "開啟地圖", style: .default) { (action) in
            var latitude = 25.04135567158161
            var longitude = 121.56782966774814
            
            if let currentSelectedItem = self.currentSelectedItem {
                latitude = currentSelectedItem.latitude
                longitude = currentSelectedItem.longitude
            }
            
            if let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // 如果 Google Maps 应用未安装，则使用浏览器打开
                    let browserURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")!
                    UIApplication.shared.open(browserURL, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //
        }
        
        actionSheet.addAction(action1)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func callPhoneNumberAction(_ sender: UIButton) {
        var phoneNumber = "02-233442456"
        
        if let currentSelectedItem = self.currentSelectedItem {
            phoneNumber = currentSelectedItem.contactPhone
        }
        
        if let phoneURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "錯誤", message: "您的設備不能播打電話。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "請再次確認領藥藥局，送出後即代表本次處方箋領藥完成。"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確定", for: .normal)
        alertViewController.alertType = .receivingMedicine_completed
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension NotPartnerDoneViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .receivingMedicine_completed {
            // call API
            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                prescriptionReceive(orgCode: SharingManager.sharedInstance.apns_tenantId, prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo, medicalType: SharingManager.sharedInstance.apns_medicalType, diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo, pharmacyId: "")
            }
        }
    }
}

extension NotPartnerDoneViewController: StopAuthAlertVCDelegate {
    func clickConfirmBtn() {
        // 領藥結果
        let storyboard = UIStoryboard(name: "MedResult", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedResultViewController") as! MedResultViewController
        vc.isReceiveMedicineFinish = true
        vc.receiveRecordId = self.receiveRecordIdFromSrv
        vc.needBackToRoot = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotPartnerDoneViewController {
    func prescriptionReceive(orgCode: String, prescriptionId: String,
                             medicalType: String, diagnosisNo: String, pharmacyId: String) {
        guard let currentSelectedItem = self.currentSelectedItem else {
            return
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let prescriptionReceiveReqInfo: PrescriptionReceiveModel = PrescriptionReceiveModel(tenantId: orgCode, medicalType: medicalType, diagnosisNo: diagnosisNo, prescriptionNo: prescriptionId, pharmacyId: currentSelectedItem.pharmacyId, action: "1")
        SDKManager.sdk.prescriptionReceive(postModel: prescriptionReceiveReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionReceiveRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let prescriptionReceiveRspModel = responseModel.data else {
                    return
                }
                
                self.receiveRecordIdFromSrv = prescriptionReceiveRspModel.receiveRecordId
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "StopAuthAlertVC") as! StopAuthAlertVC
                    alertViewController.mainLabel.text = "建立成功"
                    alertViewController.messageLabel.text = "點擊確認後前往「領藥結果」查看預約進度"
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.prescriptionReceive(orgCode: orgCode,
                                         prescriptionId: prescriptionId,
                                         medicalType: medicalType,
                                             diagnosisNo: diagnosisNo, pharmacyId: "")
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
        }
    }
}
