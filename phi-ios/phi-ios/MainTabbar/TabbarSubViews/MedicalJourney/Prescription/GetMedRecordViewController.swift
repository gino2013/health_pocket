//
//  GetMedRecordViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/21.
//

import UIKit
import KeychainSwift
import ProgressHUD

struct GetMedicineInfo {
    let title: String
    let status: String
    let date: String
    let receiveRecordId: Int
    
    init(title: String, status: String, date: String, receiveRecordId: Int) {
        self.title = title
        self.status = status
        self.date = date
        self.receiveRecordId = receiveRecordId
    }
}

class GetMedRecordViewController: BaseViewController {
    
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            //tblView.allowsSelection = false
            tblView.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    private let cellIdentifier = "GetMedRecordTableViewCell"
    // for Test
    private var getMedInfos: [GetMedicineInfo] = [
        GetMedicineInfo(title: "第1次領藥", status: "領取完畢", date: "2024/01/15", receiveRecordId: 1),
        GetMedicineInfo(title: "第2次領藥", status: "待領藥", date: "----/--/--", receiveRecordId: 2),
        GetMedicineInfo(title: "第3次領藥", status: "尚未開始", date: "----/--/--", receiveRecordId: 3)
    ]
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var isReceiveMedicineFinish: Bool = false
    //var currentMedicalRecordModel: MedicalRecordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        
        if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
            !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
            !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
            !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
            let reqInfo: GetPrescriptionModel = GetPrescriptionModel(tenantId: SharingManager.sharedInstance.apns_tenantId, prescriptionNo: SharingManager.sharedInstance.apns_prescriptionNo, medicalType: SharingManager.sharedInstance.apns_medicalType, diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo)
            getReceiveRecords(requestInfo: reqInfo)
        }
    }
    
    func updateUI() {
        tblView.register(nibWithCellClass: GetMedRecordTableViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshApiInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        emptyImageView.isHidden = true
        noteLabel.isHidden = true
        
        // for test
        /*
        if self.getMedInfos.count > 0 {
            self.hiddenNoNeedUI(enableHidden: true)
            self.tblView.reloadData()
        } else {
            self.hiddenNoNeedUI(enableHidden: false)
        }
        */
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    @objc func refreshApiInfos() {
        refreshControl.endRefreshing()
        // ???
    }
}

extension GetMedRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMedInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recordItemCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GetMedRecordTableViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        if indexPath.row < getMedInfos.count {
            recordItemCell.configureCell(title: getMedInfos[indexPath.row].title,
                                         status: getMedInfos[indexPath.row].status,
                                         date: getMedInfos[indexPath.row].date)
        }
        return recordItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row < getMedInfos.count {
            if getMedInfos[indexPath.row].date == "----/--/--" {
                return
            }
        }
        
        let storyboard = UIStoryboard(name: "MedResult", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedResultViewController") as! MedResultViewController
        vc.isReceiveMedicineFinish = self.isReceiveMedicineFinish
        vc.receiveRecordId = getMedInfos[indexPath.row].receiveRecordId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}

extension GetMedRecordViewController {
    func getReceiveRecords(requestInfo: GetPrescriptionModel) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.getReceiveRecords(postModel: requestInfo) {
            (responseModel: PhiResponseModel<ReceiveRecordListRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let receiveRecordList = responseModel.data,
                      let receiveRecordInfos = receiveRecordList.dataArray else {
                    return
                }
                
                self.getMedInfos.removeAll()
                
                for i in 0 ..< receiveRecordInfos.count {
                    let item: ReceiveRecordRspModel = receiveRecordInfos[i]
                    var date: String = item.receiveDate
                    
                    if item.receiveDate == "" {
                        date = "----/--/--"
                    }
                    
                    let getMedicineItem: GetMedicineInfo = GetMedicineInfo(title: "第\(item.nthReceiveTime)次領藥", status: item.showDesc, date: date, receiveRecordId: item.receiveRecordId)
                    self.getMedInfos.append(getMedicineItem)
                }
                
                DispatchQueue.main.async {
                    if self.getMedInfos.count > 0 {
                        self.hiddenNoNeedUI(enableHidden: true)
                        self.tblView.reloadData()
                    } else {
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getReceiveRecords(requestInfo: requestInfo)
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
