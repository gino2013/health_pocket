//
//  AuthSettingStep1ViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/4/16.
//

import UIKit
import ProgressHUD

class DepartmentInfo {
    var departmentName: String = ""
    var departmentId: String = ""
    var isSelected: Bool
    
    init(departmentName: String, departmentId: String, isSelected: Bool) {
        self.departmentName = departmentName
        self.departmentId = departmentId
        self.isSelected = isSelected
    }
}

class AuthSettingStep1ViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var allSelectButton: UIButton!
    
    // for Test
    /*
    private var departments: [DepartmentInfo] = [
        DepartmentInfo(departmentName: "家醫科", departmentId: "0", isSelected: false),
        DepartmentInfo(departmentName: "內科", departmentId: "1", isSelected: false),
        DepartmentInfo(departmentName: "胃腸肝膽科", departmentId: "2", isSelected: false),
        DepartmentInfo(departmentName: "婦產科", departmentId: "3", isSelected: false),
        DepartmentInfo(departmentName: "眼科", departmentId: "4", isSelected: false),
        DepartmentInfo(departmentName: "牙科", departmentId: "5", isSelected: false),
        DepartmentInfo(departmentName: "骨科", departmentId: "6", isSelected: false),
        DepartmentInfo(departmentName: "精神科", departmentId: "7", isSelected: false),
        DepartmentInfo(departmentName: "皮膚科", departmentId: "8", isSelected: false),
        DepartmentInfo(departmentName: "小兒科", departmentId: "9", isSelected: false)
    ]
    */
    private var departments: [DepartmentInfo] = []
    var isAllSelectEnable: Bool = false {
        didSet {
            if isAllSelectEnable {
                allSelectButton.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                allSelectButton.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    // var medicalDeptInfoList = [MedicalDeptRspModel]()
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權資料設定"
        replaceBackBarButtonItem()
        updateUI()
        sendFindMedicalDept(partnerId: SharingManager.sharedInstance.currentAuthPartnerId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        for i in 0 ..< departments.count {
            let departmentInfo: DepartmentInfo = departments[i]
            
            if i == departments.count - 1 {
                setItemView(departmentName: departmentInfo.departmentName, addBottomLine: false, itemIndex: i)
            } else {
                setItemView(departmentName: departmentInfo.departmentName, addBottomLine: true, itemIndex: i)
            }
        }
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        //scrollView.contentOffset = .zero
        scrollView.layoutIfNeeded()
    }
    
    func updateUI() {
        itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        configureButtons(enable: false)
        
        // 移除所有 subView
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func getSelectItemNumber() -> Int {
        var itemNum: Int = 0
        
        for i in 0 ..< departments.count {
            if departments[i].isSelected {
                itemNum += 1
            }
        }
        
        return itemNum
    }
    
    func saveSelectedDeptInfos() {
        SharingManager.sharedInstance.currDeptNames.removeAll()
        SharingManager.sharedInstance.currDeptCodes.removeAll()
        
        departments.forEach {
            if $0.isSelected {
                SharingManager.sharedInstance.currDeptNames.append($0.departmentName)
                SharingManager.sharedInstance.currDeptCodes.append($0.departmentId)
            }
        }
    }
    
    func checkIfEnableButton() {
        configureButtons(enable: false)
        
        for i in 0 ..< departments.count {
            if departments[i].isSelected {
                configureButtons(enable: true)
                break
            }
        }
    }
    
    func configureButtons(enable: Bool) {
        if enable {
            cancelButton.isEnabled = true
            cancelButton.backgroundColor = UIColor.white
            cancelButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1), for: .normal)
            cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            cancelButton.layer.borderWidth = 1.0
            
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            sendButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            sendButton.layer.borderWidth = 1.0
        } else {
            cancelButton.isEnabled = false
            cancelButton.backgroundColor = UIColor.white
            cancelButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
            //cancelButton.setTitleColor(UIColor(hex: "#2E8BC7", alpha: 1.0), for: .normal)
            cancelButton.layer.borderColor = UIColor(hex: "#B5BABC", alpha: 1)!.cgColor
            cancelButton.layer.borderWidth = 1.0
            
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            sendButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
            //sendButton.setTitleColor(UIColor.white, for: .normal)
            sendButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
            sendButton.layer.borderWidth = 1.0
        }
    }
    
    func processAllSelect(isAllSelectEnable: Bool) {
        if isAllSelectEnable {
            departments.forEach { $0.isSelected = true }
        } else {
            departments.forEach { $0.isSelected = false }
        }
        
        configureButtons(enable: isAllSelectEnable)
        
        for subview in itemListView.arrangedSubviews {
            let tmpView: MedicalItemSelectView = subview as! MedicalItemSelectView
            
            tmpView.isSelect = isAllSelectEnable
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AuthSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthSettingStep2ViewController") as! AuthSettingStep2ViewController
        saveSelectedDeptInfos()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ClickAllSelectAction(_ sender: UIButton) {
        isAllSelectEnable = !isAllSelectEnable
        processAllSelect(isAllSelectEnable: isAllSelectEnable)
    }
}

extension AuthSettingStep1ViewController {
    private func setItemView(departmentName: String, addBottomLine: Bool, itemIndex: Int, isSelect: Bool) {
        // Note: Change to use TableView to implement ???
        let view = MedicalItemSelectView()
        
        view.itemText = departmentName
        view.addBottomLine = addBottomLine
        view.currentItemType = .HomeMedicine
        view.isSelect = isSelect
        view.delegate = self
        view.currentIndex = itemIndex
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 60.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: MedicalItemSelectView) {
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

extension AuthSettingStep1ViewController: MedicalItemSelectViewDelegate {
    func selectMedicalItem(itemType: MedicalItemType, itemIndex: Int) {
        if itemIndex < departments.count {
            departments[itemIndex].isSelected = true
            checkIfEnableButton()
            
            if getSelectItemNumber() != departments.count {
                isAllSelectEnable = false
            } else {
                isAllSelectEnable = true
            }
        }
    }
    
    func deSelectMedicalItem(itemType: MedicalItemType, itemIndex: Int) {
        if itemIndex < departments.count {
            departments[itemIndex].isSelected = false
            checkIfEnableButton()
            
            if getSelectItemNumber() != departments.count {
                isAllSelectEnable = false
            } else {
                isAllSelectEnable = true
            }
        }
    }
}

extension AuthSettingStep1ViewController {
    func sendFindMedicalDept(partnerId: Int) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let findMedicalDeptModelReqInfo: FindMedicalDeptModel = FindMedicalDeptModel(partnerId: partnerId)
        SDKManager.sdk.findMedicalDept(postModel: findMedicalDeptModelReqInfo) {
            (responseModel: PhiResponseModel<MedicalDeptListRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicalDeptList = responseModel.data,
                      let medicalDeptInfos = medicalDeptList.dataArray else {
                    return
                }
                
                for i in 0 ..< medicalDeptInfos.count {
                    let deptItem: DepartmentInfo = DepartmentInfo(departmentName: medicalDeptInfos[i].name, departmentId: medicalDeptInfos[i].code, isSelected: medicalDeptInfos[i].hasAuthorized)
                    
                    self.departments.append(deptItem)
                    //self.medicalDeptInfoList.append(deptItem)
                }
                
                DispatchQueue.main.async {
                    for i in 0 ..< self.departments.count {
                        let departmentInfo: DepartmentInfo = self.departments[i]
                        
                        if i == self.departments.count - 1 {
                            self.setItemView(departmentName: departmentInfo.departmentName, addBottomLine: false, itemIndex: i, isSelect: departmentInfo.isSelected)
                        } else {
                            self.setItemView(departmentName: departmentInfo.departmentName, addBottomLine: true, itemIndex: i, isSelect: departmentInfo.isSelected)
                        }
                    }
                    
                    let selectItemNum: Int = self.getSelectItemNumber()
                    if selectItemNum > 0 {
                        self.checkIfEnableButton()
                        if selectItemNum != self.departments.count {
                            self.isAllSelectEnable = false
                        } else {
                            self.isAllSelectEnable = true
                        }
                    } else {
                        // first auth
                        self.isAllSelectEnable = true
                        self.processAllSelect(isAllSelectEnable: true)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendFindMedicalDept(partnerId: SharingManager.sharedInstance.currentAuthPartnerId)
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
