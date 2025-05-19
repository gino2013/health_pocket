//
//  AddInsuranceVC.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/23.
//

import UIKit
import ProgressHUD
import KeychainSwift

// 使用 `Codable` 進行 JSON 解碼
struct InsuranceProductResponse: Codable {
    let data: [InsuranceProduct]
}

struct InsuranceProduct: Codable {
    let productCode: String
    let productName: String
    let companyName: String
    let simpleCode: String?
    let units: String
}

protocol AddInsuranceVCDelegate: AnyObject {
    func showPanModalAndUpdateDataSource(policyInfo: PolicyInformation)
}

class AddInsuranceVC: BaseViewController {
    
    // MARK: - UI Outlets
    @IBOutlet weak var vpzqsmuInputView: InsuranceInputView!
    @IBOutlet weak var qpaovuNameInputView: InsuranceInputView!
    @IBOutlet weak var unitInputView: InsuranceInputView!
    @IBOutlet weak var contractDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerBaseView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    var retryExecuted = false
    var companies = [String]()
    var products = [String]()
    // Key: productName, Value: productCode
    var productsDict = [String: String]()
    var unitsArray = [String]()
    var insuranceData = [InsuranceProduct]()
    var currentVpzqsmu = ""
    var currentProduct = ""
    var currentUnit = ""
    weak var delegate: AddInsuranceVCDelegate?
    // 定義一個閉包來接收資料
    var onDataReceived: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 讀取JSON資料
        loadJSONData()
    }
    
    // checkmarx
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
    }
    
    // checkmarx
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        title = "理賠試算"
        replaceBackBarButtonItem()
        configureInputViews()
        configureButtonUI()
        configTextFieldDelegate()
        setupDatePicker()
    }
    
    private func setupInputView(_ inputView: InsuranceInputView, type: InsuranceInputType, isEditable: Bool, isRequired: Bool, isEnableSelectFunction: Bool) {
        inputView.textField.keyboardType = .default
        inputView.isValidatePass = false
        inputView.currentInputType = type
        inputView.isEditable = isEditable
        inputView.isRequired = isRequired
        inputView.enableSelectFunction = isEnableSelectFunction
        inputView.delegate = self
    }
    
    private func configureInputViews() {
        setupInputView(vpzqsmuInputView, type: .insuranceVpzqsmuName, isEditable: true, isRequired: true, isEnableSelectFunction: true)
        setupInputView(qpaovuNameInputView, type: .qpaovuName, isEditable: false, isRequired: true, isEnableSelectFunction: false)
        setupInputView(unitInputView, type: .insuredAmount, isEditable: false, isRequired: true, isEnableSelectFunction: false)
    }
    
    private func setupDatePicker() {
        contractDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        datePickerBaseView.layer.cornerRadius = 6
        datePickerBaseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
        datePickerBaseView.layer.borderWidth = 1
        datePickerBaseView.layer.masksToBounds = true
    }
    
    private func configureButton(_ button: UIButton, titleColor: UIColor, titleColorDisable: UIColor, backgroundColor: UIColor, borderColor: UIColor, isEnabled: Bool = true) {
        button.isEnabled = isEnabled
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColorDisable, for: .disabled)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = borderColor.cgColor
    }
    
    private func configureButtonUI() {
        configureButton(cancelButton, titleColor: UIColor(hex: "#2E8BC7", alpha: 1.0)!, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#FFFFFF", alpha: 1.0)!, borderColor: UIColor(hex: "#3399DB", alpha: 1)!)
        configureButton(addButton, titleColor: UIColor.white, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#EFF0F1", alpha: 1.0)!, borderColor: UIColor(hex: "#EFF0F1", alpha: 1)!, isEnabled: false)
        configureButton(searchButton, titleColor: UIColor.white, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#EFF0F1", alpha: 1.0)!, borderColor: UIColor(hex: "#EFF0F1", alpha: 1)!, isEnabled: false)
    }
    
    private func configTextFieldDelegate() {
        // 綁定 vpzqsmuInputView 當編輯結束時觸發
        [vpzqsmuInputView, unitInputView].forEach {
            $0?.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        }
    }
    
    private func updateAddButtonState() {
        let isFormValid = [vpzqsmuInputView, qpaovuNameInputView, unitInputView].allSatisfy { $0?.isValidatePass == true }
        if isFormValid {
            self.configureButton(addButton, titleColor: UIColor.white, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#3399DB", alpha: 1.0)!, borderColor: UIColor(hex: "#3399DB", alpha: 1)!, isEnabled: true)
        } else {
            configureButton(addButton, titleColor: UIColor.white, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#EFF0F1", alpha: 1.0)!, borderColor: UIColor(hex: "#EFF0F1", alpha: 1)!, isEnabled: false)
        }
    }
    
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == vpzqsmuInputView.textField {
            vpzqsmuInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            vpzqsmuInputView.baseView.layer.borderWidth = 1.0
            vpzqsmuInputView.errorNoteLabel.isHidden = true
            vpzqsmuInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                vpzqsmuInputView.isValidatePass = true
            }
        } else if textField == qpaovuNameInputView.textField {
            qpaovuNameInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            qpaovuNameInputView.baseView.layer.borderWidth = 1.0
            qpaovuNameInputView.errorNoteLabel.isHidden = true
            qpaovuNameInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                qpaovuNameInputView.isValidatePass = true
            }
        } else if textField == unitInputView.textField {
            unitInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            unitInputView.baseView.layer.borderWidth = 1.0
            unitInputView.errorNoteLabel.isHidden = true
            unitInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                unitInputView.isValidatePass = true
            }
        }
        
        updateAddButtonState()
    }
    
    func loadJSONData() {
        if let path = Bundle.main.path(forResource: "insuranceProduct", ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                // 解碼最外層物件，並取得 `data` 裡的陣列
                let decodedResponse = try decoder.decode(InsuranceProductResponse.self, from: jsonData)
                insuranceData = decodedResponse.data
                // 獲取所有唯一的公司名稱並排序
                companies = Array(Set(insuranceData.map { $0.companyName })).sorted()
                // 刷新第一個 PickerView
                // vpzqsmuPickerView.reloadAllComponents()
                // 檢查是否包含 "國泰人壽"，並將其移到第一位
                if let index = companies.firstIndex(of: "國泰人壽") {
                    let cathayLife = companies.remove(at: index)
                    companies.insert(cathayLife, at: 0)
                }
                
                // 提取所有唯一的產品名稱和對應的產品代碼
                for product in insuranceData {
                    productsDict[product.productName] = product.productCode
                }
            } catch {
                print("讀取或解析 JSON 時出錯: \(error.localizedDescription)")
            }
        }
    }
    
    /*
    func loadJSONData() {
        if let path = Bundle.main.path(forResource: "insuranceProduct", ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(InsuranceProductResponse.self, from: jsonData)
                print("JSON 解碼成功: \(decodedResponse)")
            } catch let DecodingError.dataCorrupted(context) {
                print("資料損毀: \(context.debugDescription)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("缺少關鍵鍵值 '\(key.stringValue)' 在 \(context.codingPath)")
            } catch let DecodingError.typeMismatch(type, context) {
                print("型別不匹配: 預期型別 \(type) 在 \(context.codingPath)")
            } catch let DecodingError.valueNotFound(value, context) {
                print("缺少預期值 '\(value)' 在 \(context.codingPath)")
            } catch {
                print("其他錯誤: \(error.localizedDescription)")
            }
        } else {
            print("無法載入 JSON 檔案")
        }
    }
    */
    
    // 隱藏鍵盤，如果點擊了文字方塊以外的區域
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let dateStr: String = DateTimeUtils.convertDateToTimeString(srcDate: self.contractDatePicker.date, formate: "yyyy-MM-dd")
        let pInfo: PolicyInformation = PolicyInformation(vpzqsmuName: currentVpzqsmu, productName: currentProduct, unit: currentUnit, contractDate: dateStr, productCode: productsDict[currentProduct] ?? currentProduct)
        delegate?.showPanModalAndUpdateDataSource(policyInfo: pInfo)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SearchPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchPolicyViewController") as! SearchPolicyViewController
        products = insuranceData.filter { $0.companyName == self.currentVpzqsmu }.map { $0.productName }
        vc.firstTimeData = self.products
        // 設定閉包來接收從 SecondViewController 傳回的資料
        vc.onSaveItem = { [weak self] item in
            guard let self = self else { return }
            self.currentProduct = item
            DispatchQueue.main.async {
                self.qpaovuNameInputView.textField.text = self.currentProduct
                self.unitInputView.textField.text = ""
                self.unitInputView.enableSelectFunction = true
                self.unitInputView.isEditable = true
                self.processEndEditing(self.qpaovuNameInputView.textField)
            }
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentSelectionVC(title: String, items: [String], onSelect: @escaping (String) -> Void) {
        let storyboard = UIStoryboard(name: "SelectContent", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectContentVC") as? SelectContentVC else { return }
        
        vc.viewTitle = title
        vc.itemArray = items
        vc.onSaveItem = { item in
            onSelect(item)
            self.updateAddButtonState()
        }
        
        present(vc, animated: false)
    }
}

extension AddInsuranceVC {
    func textFieldDidChange(textField: UITextField) {
        processEndEditing(textField)
    }
}

extension AddInsuranceVC: InsuranceInputViewDelegate {
    func showInsuranceVpzqsmuSelectView() {
        presentSelectionVC(title: "保險公司", items: companies) { [weak self] item in
            guard let self = self else { return }
            self.currentVpzqsmu = item
            
            DispatchQueue.main.async {
                self.configureButton(self.searchButton, titleColor: UIColor.white, titleColorDisable: UIColor(hex: "#C7C7C7", alpha: 1.0)!, backgroundColor: UIColor(hex: "#3399DB", alpha: 1.0)!, borderColor: UIColor(hex: "#3399DB", alpha: 1)!, isEnabled: true)
                self.vpzqsmuInputView.textField.text = self.currentVpzqsmu
                self.qpaovuNameInputView.textField.text = ""
                //self.qpaovuNameInputView.enableSelectFunction = true
                self.unitInputView.textField.text = ""
                self.qpaovuNameInputView.isValidatePass = false
                self.unitInputView.isValidatePass = false
                self.textFieldDidChange(textField: self.vpzqsmuInputView.textField)
            }
        }
    }
    
    func showQpaovuNameSelectView() {
        products = insuranceData.filter { $0.companyName == currentVpzqsmu }.map { $0.productName }
        presentSelectionVC(title: "保險名稱", items: products) { [weak self] item in
            guard let self = self else { return }
            
            self.currentProduct = item
            
            DispatchQueue.main.async {
                self.qpaovuNameInputView.textField.text = self.currentProduct
                self.unitInputView.textField.text = ""
                self.unitInputView.enableSelectFunction = true
                self.unitInputView.isEditable = true
                self.unitInputView.isValidatePass = false
                self.textFieldDidChange(textField: self.qpaovuNameInputView.textField)
            }
        }
    }
    
    func showInsuredAmountSelectView() {
        unitsArray = insuranceData.first(where: { $0.productName == currentProduct })?.units.split(separator: ",").map { String($0) } ?? []
        presentSelectionVC(title: "投保單位", items: unitsArray) { [weak self] item in
            guard let self = self else { return }
            
            self.currentUnit = item
            
            DispatchQueue.main.async {
                self.unitInputView.textField.text = self.currentUnit
                self.textFieldDidChange(textField: self.unitInputView.textField)
            }
        }
    }
}

extension AddInsuranceVC {
    static func instance() -> AddInsuranceVC {
        let viewController = AddInsuranceVC(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension AddInsuranceVC {
    // Data too large 25MB, use local data to test
    func getInsuranceproduct() {
        SDKManager.ezclaimSdk.insuranceproductSimple() {
            (responseModel: EzclaimRspModel<InsuranceProductRspModel>) in
            
            if responseModel.success {
                guard let rspInfoArray = responseModel.data, let _ = rspInfoArray.first else {
                    return
                }
                
                // 遍歷數組並處理每個疾病信息
                for rspInfo in rspInfoArray {
                    print("Product Code: \(rspInfo.productCode)")
                    print("Product Name: \(rspInfo.productName)")
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
            
            ProgressHUD.dismiss()
        }
    }
}
