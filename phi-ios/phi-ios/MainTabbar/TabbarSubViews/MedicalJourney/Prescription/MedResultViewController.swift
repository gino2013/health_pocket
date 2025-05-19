//
//  MedResultViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/20.
//

import UIKit
import ProgressHUD

class MedResultViewController: BaseViewController {
    
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var getMedTimeLabel: UILabel!
    @IBOutlet weak var nextGetMedTimeLabel: UILabel!
    
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medAddressLabel: UILabel!
    @IBOutlet weak var medPhoneLabel: UILabel!
    @IBOutlet var businessHoursLabelArray: [UILabel]!
    
    @IBOutlet weak var medHistoryButton: UIButton!
    @IBOutlet weak var addAlertButton: UIButton!
    
    var retryExecuted: Bool = false
    var isReceiveMedicineFinish: Bool = false
    var receiveRecordId: Int = 0
    var needBackToRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "領藥結果"
        replaceBackBarButtonItem()
        updateUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData),
            name: .MedResultVC_Reload,
            object: nil
        )
        
        if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
            !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
            !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
            !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
            
            let reqInfo: GetReceiveRecordDetailModel = GetReceiveRecordDetailModel(tenantId: SharingManager.sharedInstance.apns_tenantId, prescriptionNo: SharingManager.sharedInstance.apns_prescriptionNo, medicalType: SharingManager.sharedInstance.apns_medicalType, diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo, receiveRecordId: "\(self.receiveRecordId)")
            getReceiveRecordsDetail(requestInfo: reqInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharingManager.sharedInstance.isMedResultViewController = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SharingManager.sharedInstance.isMedResultViewController = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadData() {
        if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
            !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
            !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
            !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
            
            let reqInfo: GetReceiveRecordDetailModel = GetReceiveRecordDetailModel(tenantId: SharingManager.sharedInstance.apns_tenantId, prescriptionNo: SharingManager.sharedInstance.apns_prescriptionNo, medicalType: SharingManager.sharedInstance.apns_medicalType, diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo, receiveRecordId: "\(self.receiveRecordId)")
            getReceiveRecordsDetail(requestInfo: reqInfo)
        }
    }
    
    func updateUI() {
        firstBaseView.layer.cornerRadius = 8
        firstBaseView.layer.borderWidth = 1
        firstBaseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
        secondBaseView.layer.cornerRadius = 8
        secondBaseView.layer.borderWidth = 1
        secondBaseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
        medHistoryButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        medHistoryButton.layer.borderWidth = 1.0
    }
    
    func updateUI(fromSrvRsp: ReceiveRecordDetailRspModel) {
        getMedTimeLabel.text = fromSrvRsp.receiveDate
        nextGetMedTimeLabel.text = fromSrvRsp.nextReceiveDate
        //======
        medNameLabel.text = fromSrvRsp.pharmacyInfo.name
        medAddressLabel.text = fromSrvRsp.pharmacyInfo.address
        medPhoneLabel.text = fromSrvRsp.pharmacyInfo.contactPhone
        
        for (index, time) in fromSrvRsp.pharmacyInfo.businessHours.enumerated() {
            businessHoursLabelArray[index].text = time
        }
    }
    
    @IBAction func medHistoryAction(_ sender: UIButton) {
        if isReceiveMedicineFinish {
            let storyboard = UIStoryboard(name: "GetMedicine", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GetMedRecordViewController") as! GetMedRecordViewController
            vc.isReceiveMedicineFinish = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addAlertAction(_ sender: UIButton) {
        if SharingManager.sharedInstance.currAutoImportPrescriptionInfos.count == 1 {
            // 1 medicine flow
            let storyboard = UIStoryboard(name: "ManualSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ManualSettingStep2ViewController") as! ManualSettingStep2ViewController
            //SharingManager.sharedInstance.currentSetReminderMode = .fromMedicineResult
            SharingManager.sharedInstance.currentSetReminderMode = .auto
            vc.isPushedFromMedResultVC = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Reminder", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedReminderViewController") as! MedReminderViewController
            SharingManager.sharedInstance.currentSetReminderMode = .auto
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc override func popPresentedViewController() {
        if needBackToRoot {
            needBackToRoot = false
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MedResultViewController {
    func getReceiveRecordsDetail(requestInfo: GetReceiveRecordDetailModel) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.getReceiveRecordsDetail(postModel: requestInfo) {
            (responseModel: PhiResponseModel<ReceiveRecordDetailRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let receiveRecordDetailInfo = responseModel.data else {
                    return
                }
                                
                DispatchQueue.main.async {
                    self.updateUI(fromSrvRsp: receiveRecordDetailInfo)
                    
                    if self.needBackToRoot {
                        self.medHistoryButton.isHidden = true
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getReceiveRecordsDetail(requestInfo: requestInfo)
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
