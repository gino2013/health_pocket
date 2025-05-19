//
//  FinishMedJourneyVController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/4/24.
//

import UIKit
import ProgressHUD

class FinishMedJourneyVController: BaseViewController {
    
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.dataSource = self
            historyTableView.delegate = self
            historyTableView.tableFooterView = UIView()
            historyTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            historyTableView.separatorStyle = .none
            //historyTableView.allowsSelection = false
            historyTableView.rowHeight = UITableView.automaticDimension
            historyTableView.estimatedRowHeight = 2
            historyTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    private let cellIdentifier = "MedicalHistoryTViewCell"
    //var medicalHistorys: [String] = []
    // Test Data
    var data = sampleData()
    // Server Data
    var medicalRecordInfoList: [MedicalRecordRspModel]?
    //var data = [MedHistoryTViewCellViewModel]()
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData),
            name: .FinishMedVC_Reload,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharingManager.sharedInstance.isFinishMedJourneyVController = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func reloadData() {
        SharingManager.sharedInstance.isFinishMedJourneyVController = true
        getMedRecordWithPrescription(medicalType: "1")
    }
    
    func updateUI() {
        historyTableView.register(nibWithCellClass: MedicalHistoryTViewCell.self)
        emptyImageView.isHidden = true
        noteLabel.isHidden = true
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        historyTableView.isHidden = !enableHidden
    }
}

extension FinishMedJourneyVController: UITableViewDelegate, UITableViewDataSource {
    func closeOtherExpandedCell(index: Int) {
        for i in 0 ..< data.count {
            if i != index {
                if data[i].expanded == true {
                    data[i].expanded = false
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicalHistoryTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        cell.selectionStyle = .none
        let model = data[indexPath.row]
        cell.stackView.arrangedSubviews[1].isHidden = !model.expanded
        cell.configureCell(viewModel: model)
        cell.cellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        let isExpanded = data[indexPath.row].expanded
        data[indexPath.row].expanded = !isExpanded
                
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension FinishMedJourneyVController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        //
    }
}

extension FinishMedJourneyVController {
    func dumpSrvDataToViewModel(from: MedicalRecordRspModel, isFirstItem: Bool) -> MedHistoryTViewCellViewModel {
        let nthReceiveTimeStr: String = "第\(from.nthReceiveTime)次領藥"
        let dataRangeStr: String = "\(from.opdDate)-\(from.endDate)"
        
        if isFirstItem {
            return MedHistoryTViewCellViewModel(hospitalName: from.hospitalName, type: medicalTypeMapping[from.medicalType] ?? "", nthReceiveTime: nthReceiveTimeStr, date: from.opdDate, name: from.physicianName, diseaseType: from.icdName, dateRange: dataRangeStr, rcvStatus: from.receiveStatus, rcvStatusDesc: from.receiveStatusDesc, tenantId: from.tenantId, prescriptionId: from.prescriptionNo, isPrescriptionEnded: from.isPrescriptionEnded, expanded: true)
        }
        
        return MedHistoryTViewCellViewModel(hospitalName: from.hospitalName, type: medicalTypeMapping[from.medicalType] ?? "", nthReceiveTime: nthReceiveTimeStr, date: from.opdDate, name: from.physicianName, diseaseType: from.icdName, dateRange: dataRangeStr, rcvStatus: from.receiveStatus, rcvStatusDesc: from.receiveStatusDesc, tenantId: from.tenantId, prescriptionId: from.prescriptionNo, isPrescriptionEnded: from.isPrescriptionEnded, expanded: false)
    }
    
    func getMedRecordWithPrescription(medicalType: String) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getMedRecordWithPrescriptionReqInfo: GetMedRecWithPrescriptionModel = GetMedRecWithPrescriptionModel(medicalType: medicalType, ongoingPrescription: false)
        SDKManager.sdk.getMedRecordWithPrescription(postModel: getMedRecordWithPrescriptionReqInfo) {
            (responseModel: PhiResponseModel<MedicalRecordListRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicalRecordListRspModel = responseModel.data,
                      let medicalRecordDataArray = medicalRecordListRspModel.dataArray else {
                    return
                }
                
                self.medicalRecordInfoList = medicalRecordDataArray
                
                self.data.removeAll()
                
                for i in 0 ..< medicalRecordDataArray.count {
                    let recordItem: MedicalRecordRspModel = medicalRecordDataArray[i]

                    if i == 0 {
                        self.data.append(self.dumpSrvDataToViewModel(from: recordItem, isFirstItem: true))
                    } else {
                        self.data.append(self.dumpSrvDataToViewModel(from: recordItem, isFirstItem: false))
                    }
                }
                
                if self.data.count > 0 {
                    DispatchQueue.main.async {
                        //self.alertInfoView.isHidden = true
                        self.hiddenNoNeedUI(enableHidden: true)
                        self.historyTableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        //self.alertInfoView.isHidden = true
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                }
                
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMedRecordWithPrescription(medicalType: "1")
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

extension FinishMedJourneyVController: MedicalHistoryTViewCellDelegate {
    func didTapLeftButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int) {
        if let medicalRecordInfoList = self.medicalRecordInfoList {
            let selectItem: MedicalRecordRspModel = medicalRecordInfoList[index]
            let storyboard = UIStoryboard(name: "MedLocation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedLocationViewController") as! MedLocationViewController
            vc.hidesBottomBarWhenPushed = true
            //SharingManager.sharedInstance.currentMedicalRecordModel = selectItem
            if SharingManager.sharedInstance.isPushNotificationMode == false {
                SharingManager.sharedInstance.apns_tenantId = selectItem.tenantId
                SharingManager.sharedInstance.apns_medicalType = selectItem.medicalType
                SharingManager.sharedInstance.apns_diagnosisNo = selectItem.diagnosisNo
                SharingManager.sharedInstance.apns_prescriptionNo = selectItem.prescriptionNo
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapRightButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int) {
        if let medicalRecordInfoList = self.medicalRecordInfoList {
            let selectItem: MedicalRecordRspModel = medicalRecordInfoList[index]
            
            let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
            vc.hidesBottomBarWhenPushed = true
            // vc.currentMedicalRecordModel = selectItem
            //SharingManager.sharedInstance.currentMedicalRecordModel = selectItem
            if SharingManager.sharedInstance.isPushNotificationMode == false {
                SharingManager.sharedInstance.apns_tenantId = selectItem.tenantId
                SharingManager.sharedInstance.apns_medicalType = selectItem.medicalType
                SharingManager.sharedInstance.apns_diagnosisNo = selectItem.diagnosisNo
                SharingManager.sharedInstance.apns_prescriptionNo = selectItem.prescriptionNo
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
