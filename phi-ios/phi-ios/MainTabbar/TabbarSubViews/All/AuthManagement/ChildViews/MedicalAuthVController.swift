//
//  MedicalAuthVController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/1/30.
//

import UIKit
import KeychainSwift
import ProgressHUD

class MedicalAuthVController: BaseViewController {
    
    @IBOutlet weak var hTableView: UITableView! {
        didSet {
            hTableView.dataSource = self
            hTableView.delegate = self
            hTableView.tableFooterView = UIView()
            hTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            hTableView.separatorStyle = .none
            //tblView.allowsSelection = false
            hTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var addAuthButton: UIButton!
    
    private let cellIdentifier = "AuthHospitailTableViewCell"
    //var authHospitals: [String] = []
    var medicalPartnerInfoList = [MedicalPartnerRspModel]()
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAuthorizedPartnerList()
        
        // For Demo
        /*
        if SharingManager.sharedInstance.authDoneHospitals.count > 0 {
            authHospitals = SharingManager.sharedInstance.authDoneHospitals
            hTableView.reloadData()
        }
        */
    }
    
    func updateUI() {
        hTableView.register(nibWithCellClass: AuthHospitailTableViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshHospitalInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        hTableView.addSubview(refreshControl)
    }
    
    @objc func refreshHospitalInfos() {
        refreshControl.endRefreshing()
        //getHospitalList()
    }
    
    @IBAction func AddMedicalAuthAction(_ sender: UIButton) {
        processAddMedialAuth()
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        addAuthButton.isHidden = enableHidden
        hTableView.isHidden = !enableHidden
    }
    
    func processAddMedialAuth() {
        let storyboard = UIStoryboard(name: "Hospital", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HospitalListViewController") as! HospitalListViewController
        SharingManager.sharedInstance.currentAuthType = .addAuthorization
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MedicalAuthVController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalPartnerInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let hospitalItemCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AuthHospitailTableViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        if indexPath.row < medicalPartnerInfoList.count {
            hospitalItemCell.configureCell(title: medicalPartnerInfoList[indexPath.row].organizationName, buttonTitle: "")
        }
        return hospitalItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let hospitalItem = medicalPartnerInfoList[indexPath.row]
        let storyboard = UIStoryboard(name: "AuthDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthDetailViewController") as! AuthDetailViewController
        vc.currentPartnerId = hospitalItem.id
        SharingManager.sharedInstance.currentAuthPartnerId = hospitalItem.id
        vc.hospitalName = hospitalItem.organizationName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension MedicalAuthVController {
    func getAuthorizedPartnerList() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let keychain = KeychainSwift()
        let idTokenForAPI: String = keychain.get("idToken") ?? ""
        
        SDKManager.sdk.getAuthorizedPartnerList(idTokenForAPI) {
            (responseModel: PhiResponseModel<MedicalPartnerListRspModel>) in
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicalPartnerList = responseModel.data,
                      let medicalPartnerInfos = medicalPartnerList.dataArray else {
                    return
                }
                
                self.medicalPartnerInfoList.removeAll()
                
                for i in 0 ..< medicalPartnerInfos.count {
                    let partnerItem: MedicalPartnerRspModel = medicalPartnerInfos[i]
                    
                    self.medicalPartnerInfoList.append(partnerItem)
                }
                
                DispatchQueue.main.async {
                    //if SharingManager.sharedInstance.authDoneHospitals.count > 0 {
                    if self.medicalPartnerInfoList.count > 0 {
                        self.hiddenNoNeedUI(enableHidden: true)
                    } else {
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                    
                    self.hTableView.reloadData()
                }
               
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getAuthorizedPartnerList()
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
