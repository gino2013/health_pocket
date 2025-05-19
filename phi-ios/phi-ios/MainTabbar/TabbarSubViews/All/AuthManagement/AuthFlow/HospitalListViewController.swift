//
//  HospitalListViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/4/11.
//

import UIKit
import KeychainSwift
import ProgressHUD

class HospitalListViewController: BaseViewController {
    
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
    
    private let cellIdentifier = "AuthHospitailTableViewCell"
    // for Test
    private var hospitals: [String] = ["國泰醫院", "臺大醫院", "健康醫院", "平安醫院"]
    var medicalPartnerInfoList = [MedicalPartnerRspModel]()
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    private var isFirstTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getHospitalList()
    }
    
    func updateUI() {
        tblView.register(nibWithCellClass: AuthHospitailTableViewCell.self)
        
        refreshControl.addTarget(self, action: #selector(refreshHospitalInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        /*
         memberInfoTopView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
         functionListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
         */
    
        /*
        tblView.contentInsetAdjustmentBehavior = .never

        let topInset: CGFloat = 20.0 // 頂部間距
        let bottomInset: CGFloat = 20.0 // 底部間距
        tblView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
         */
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    func pushToNextPage() {
        let hospitalItem = medicalPartnerInfoList.first!
        let storyboard = UIStoryboard(name: "AuthPrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthPrivacyPolicyViewController") as! AuthPrivacyPolicyViewController
        vc.hospitalName = hospitalItem.organizationName
        SharingManager.sharedInstance.currentAuthPartnerId = hospitalItem.id
        // Keep original authType setting.
        SharingManager.sharedInstance.currentAuthType = .firstAuthorization
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refreshHospitalInfos() {
        refreshControl.endRefreshing()
        getHospitalList()
    }
    
    func getHospitalList() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let keychain = KeychainSwift()
        let idTokenForAPI: String = keychain.get("idToken") ?? ""
        
        SDKManager.sdk.getMedicalPartnerList(idTokenForAPI) {
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
                    
                    if !partnerItem.hasAuthorized {
                        self.medicalPartnerInfoList.append(partnerItem)
                    }
                }
                
                DispatchQueue.main.async {
                    if self.medicalPartnerInfoList.count > 0 {
                        self.hiddenNoNeedUI(enableHidden: true)
                        
                        self.tblView.reloadData()
                        
                        if self.isFirstTime {
                            self.isFirstTime = false
                            
                            if SharingManager.sharedInstance.currentAuthType == .firstAuthorization {
                                self.pushToNextPage()
                            }
                        }
                        
                    } else {
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                }
               
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getHospitalList()
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

extension HospitalListViewController: UITableViewDelegate, UITableViewDataSource {
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
        let storyboard = UIStoryboard(name: "AuthPrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthPrivacyPolicyViewController") as! AuthPrivacyPolicyViewController
        vc.hospitalName = hospitalItem.organizationName
        SharingManager.sharedInstance.currentAuthPartnerId = hospitalItem.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
