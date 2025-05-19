//
//  InsurancePolicyInfoListVC.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/20.
//

import UIKit
import KeychainSwift
import ProgressHUD
import PanModal

struct PolicyInformation {
    let vpzqsmuName: String
    let productName: String
    let unit: String
    let contractDate: String
    let productCode: String
    
    init(vpzqsmuName: String, productName: String, unit: String, contractDate: String, productCode: String) {
        self.vpzqsmuName = vpzqsmuName
        self.productName = productName
        self.unit = unit
        self.contractDate = contractDate
        self.productCode = productCode
    }
}

class InsurancePolicyInfoListVC: BaseViewController {
    
    @IBOutlet weak var insuranceTitle: UILabel!
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            tblView.allowsSelection = false
            tblView.showsVerticalScrollIndicator = false
            tblView.rowHeight = UITableView.automaticDimension
            tblView.estimatedRowHeight = 64
        }
    }
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var addInsuranceButton: UIButton!
    @IBOutlet weak var trialCalculationButton: UIButton!
    
    private let cellIdentifier = "ExtPolicyInfoTViewCell"
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var showPanModal: Bool = false
    var currentData: [PolicyInfoCellViewModel] = []
    var birthday: String = "1980-10-02 " /* 1980-10-02, for test */
    var gender: String = "F" /* for test */
    var diseaseName: String = "主動脈剝離" /* for test */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        createRightBarButton()
        updateUI()
        
        hiddenNoNeedUI(enableHidden: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showPanModal {
            presentPanModal(TransientAlertViewController(alertTitle: "已新增成功！"))
            showPanModal = false
            
            if currentData.count > 0 {
                hiddenNoNeedUI(enableHidden: true)
                tblView.reloadData()
            } else {
                hiddenNoNeedUI(enableHidden: false)
            }
        }
    }
    
    func updateUI() {
        tblView.register(nibWithCellClass: ExtPolicyInfoTViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshApiInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        emptyImageView.isHidden = true
        noteLabel.isHidden = true
        addInsuranceButton.isHidden = true
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        addInsuranceButton.isHidden = enableHidden
        tblView.isHidden = !enableHidden
        insuranceTitle.isHidden = !enableHidden
        
        if enableHidden {
            trialCalculationButton.isEnabled = enableHidden
            trialCalculationButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        } else {
            trialCalculationButton.isEnabled = false
            trialCalculationButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            trialCalculationButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
            trialCalculationButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func createRightBarButton() {
        let titleLabel = UILabel()
        titleLabel.text = "新增試算保單"
        titleLabel.textColor = UIColor(hex: "#34393D")
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        
        // 创建一个 UITapGestureRecognizer 并设置其相应的处理程序
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customBarButtonTapped))
        // 将 UITapGestureRecognizer 添加到 UILabel 上
        titleLabel.addGestureRecognizer(tapGesture)
        // 开启 UILabel 的用户交互功能
        titleLabel.isUserInteractionEnabled = true
        
        // 建立 UIBarButtonItem，並設定樣式為 .plain，並將自訂的 UILabel 設定為自訂視圖
        let customBarButton = UIBarButtonItem(customView: titleLabel)
        
        //let addButton = UIBarButtonItem(title: "新增授權", style: .plain, target: self, action: #selector(addButtonTapped))
        
        // 将按钮添加到导航栏的右侧
        navigationItem.rightBarButtonItem = customBarButton
    }
    
    @objc func customBarButtonTapped() {
        pushToAddInsurancePage()
    }
    
    @objc func refreshApiInfos() {
        refreshControl.endRefreshing()
        // ???
    }
    
    func pushToAddInsurancePage() {
        let vc = AddInsuranceVC.instance()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addInsuranceAction(_ sender: UIButton) {
        pushToAddInsurancePage()
    }
    
    @IBAction func trialCalculationAction(_ sender: UIButton) {
        diseaseClaimReport()
    }
}

extension InsurancePolicyInfoListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let extPolicyInfoTViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExtPolicyInfoTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        if indexPath.row < currentData.count {
            extPolicyInfoTViewCell.delegate = self
            extPolicyInfoTViewCell.configureCell(viewModel: currentData[indexPath.row])
        }
        
        return extPolicyInfoTViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ???
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
     */
}

extension InsurancePolicyInfoListVC {
    // 將 currentData 轉換為 Policy 陣列
    func convertToPolicyArray(from currentData: [PolicyInfoCellViewModel]) -> [Policy] {
        var policyArray: [Policy] = []
        
        for cellViewModel in currentData {
            let policyInfo = cellViewModel.cellInfo
            
            // 創建 Policy 並加入陣列
            let policy = Policy(productCode: policyInfo.productCode,
                                unit: policyInfo.unit,
                                contractDate: policyInfo.contractDate)
            policyArray.append(policy)
        }
        
        return policyArray
    }
    
    func diseaseClaimReport() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        /*
        let userProfile = UserProfile(birthday: "1980-10-02", gender: "F")
        let disease = Disease(diseaseName: "主動脈剝離")
        let policy = [
            Policy(productCode: "206311MZ1D30112A31E10000000", unit: "高階款", contractDate: "2019-01-03"),
            Policy(productCode: "205311MZ1B00123A11Z10000008_10", unit: "1400", contractDate: "2018-02-19"),
            Policy(productCode: "202311M12B5D003", unit: "1300", contractDate: "2011-12-15"),
            Policy(productCode: "254131M11A28006_15", unit: "800萬", contractDate: "2012-04-05")
        ]
        */
    
        let formattedBODString = self.birthday.replacingOccurrences(of: "/", with: "-")
        let userProfile = UserProfile(birthday: formattedBODString, gender: self.gender)
        let disease = Disease(diseaseName: self.diseaseName)
        let policy = convertToPolicyArray(from: currentData)
        let requestInfo = GetEzClaimReportModel(userProfile: userProfile, disease: disease, policy: policy)
        
        SDKManager.ezclaimSdk.diseaseclaimReport(requestInfo) {
            (responseModel: EzclaimRspModel<DiseaseclaimReportRspModel>) in
            
            if responseModel.success {
                guard let rspInfoArray = responseModel.data else {
                    return
                }
                
                for rspInfo in rspInfoArray {
                    print("rspInfo=\(rspInfo.pdfFile)!")
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "InsurancePolicy", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "CalcResultViewController") as! CalcResultViewController
                        vc.hidesBottomBarWhenPushed = true
                        vc.pdfUrl = "\(ezClaimIP):8080/ezclaimPartnerFile/\(rspInfo.pdfFile)"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                    alertViewController.alertLabel.text = responseModel.message ?? ""
                    alertViewController.alertImageView.image = UIImage(named: "Error")
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }
            
            ProgressHUD.dismiss()
        }
    }
}

extension InsurancePolicyInfoListVC: AddInsuranceVCDelegate {
    func showPanModalAndUpdateDataSource(policyInfo: PolicyInformation) {
        self.showPanModal = true
    
        let vm: PolicyInfoCellViewModel = PolicyInfoCellViewModel(cellInfo: policyInfo)
        currentData.append(vm)
    }
}

extension InsurancePolicyInfoListVC: PolicyInfoTViewCellDelegate {
    func deleteDataSource(by cellId: String) {
        if let index = currentData.firstIndex(where: { $0.cellId == cellId }) {
            currentData.remove(at: index)
        } else {
            print("未找到具有 ID \(cellId) 的項目。")
        }
    }
    
    func didTapDeleteButtonAtCellUUID(uuid: String) {
        deleteDataSource(by: uuid)
        
        if currentData.count > 0 {
            hiddenNoNeedUI(enableHidden: true)
            tblView.reloadData()
        } else {
            hiddenNoNeedUI(enableHidden: false)
        }
    }
    
    func didTapDeleteButtonAtCellIndex(index: Int) {
        if index < currentData.count {
            currentData.remove(at: index)
            
            if currentData.count > 0 {
                hiddenNoNeedUI(enableHidden: true)
                tblView.reloadData()
            } else {
                hiddenNoNeedUI(enableHidden: false)
            }
        }
    }
}
