//
//  ConfirmReservationViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/6.
//

import UIKit
import ProgressHUD

class ConfirmReservationViewController: BaseViewController {
    
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
            
            for (index, time) in currentSelectedItem.businessHours.enumerated() {
                businessHoursLabelArray[index].text = time
            }
        }
    }
    
    @IBAction func openMapAction(_ sender: UIButton) {
        let actionSheet = UIAlertController()
        let action1 = UIAlertAction(title: "開啟地圖", style: .default) { (action) in
            let latitude = 25.04135567158161
            let longitude = 121.56782966774814
            
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
        let phoneNumber = "02-233442456"
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
        alertViewController.messageLabel.text = "請再次確認預約藥局，待藥品調劑完成後請至該藥局領取藥品。"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確定", for: .normal)
        alertViewController.alertType = .receivingMedicine_completed
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension ConfirmReservationViewController: TwoButtonAlertVCDelegate {
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
                prescriptionReservation(
                    orgCode: SharingManager.sharedInstance.apns_tenantId,
                    prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                    medicalType: SharingManager.sharedInstance.apns_medicalType,
                    diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo,
                    pharmacyId: "")
            }
        }
    }
}

extension ConfirmReservationViewController: StopAuthAlertVCDelegate {
    func clickConfirmBtn() {
        if let selectedItem = self.currentSelectedItem {
            let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppointStep1ViewController") as! AppointStep1ViewController
            vc.selectedItem = selectedItem
            vc.receiveRecordId = self.receiveRecordIdFromSrv
            vc.needBackToRoot = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ConfirmReservationViewController {
    func prescriptionReservation(orgCode: String, prescriptionId: String,
                                 medicalType: String, diagnosisNo: String,
                                 pharmacyId: String) {
        guard let currentSelectedItem = self.currentSelectedItem else {
            return
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let reservationModelReqInfo: PrescriptionReservationModel = PrescriptionReservationModel(tenantId: orgCode, medicalType: medicalType, diagnosisNo: diagnosisNo, prescriptionNo: prescriptionId, pharmacyId: currentSelectedItem.pharmacyId, action: ReserveAction.confirm.rawValue)
        SDKManager.sdk.prescriptionReservation(postModel: reservationModelReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionReservationRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let receiveRspModel = responseModel.data else {
                    return
                }
                
                self.receiveRecordIdFromSrv = receiveRspModel.receiveRecordId
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "StopAuthAlertVC") as! StopAuthAlertVC
                    alertViewController.mainLabel.text = "預約完成"
                    alertViewController.messageLabel.text = "點擊確認後前往「處方箋」查看預約進度"
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.prescriptionReservation(
                        orgCode: orgCode,
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
