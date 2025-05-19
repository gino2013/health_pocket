//
//  AuthTypeViewController.swift
//  pho-ios
//
//  Created by Kenneth on 2024/4/12.
//

import UIKit
import KeychainSwift
import ProgressHUD

enum AuthVerifyType: Int {
    case loginOlaaword
    case faceId
}

class AuthTypeViewController: BaseViewController {

    @IBOutlet weak var typeAView: UIView!
    @IBOutlet weak var typeAButton: UIButton!
    @IBOutlet weak var typeBView: UIView!
    @IBOutlet weak var typeBButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
        
    var currentAuthType: AuthVerifyType = .loginOlaaword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權認證"
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateUI() {
        if UserDefaults.standard.isEnableFaceId() {
            FaceIdAuthHelper.shared.askBiometricAvailability { [weak self] (error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Status: \n" + error.localizedDescription)
                    typeBView.isHidden = true
                    typeBButton.isHidden = true
                } else {
                    typeBView.isHidden = false
                    typeBView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
                }
            }
        } else {
            typeBView.isHidden = true
            typeBButton.isHidden = true
        }
        
        typeAView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func clickTypeAView(_ sender: UIButton) {
        // typeAView.layer.cornerRadius = 4
        currentAuthType = .loginOlaaword
        typeAView.layer.borderWidth = 2
        typeAView.layer.borderColor = UIColor.init(hex: "#3399DB")?.cgColor
        typeBView.layer.borderWidth = 0
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
    }
    
    @IBAction func clickTypeBView(_ sender: UIButton) {
        // typeBView.layer.cornerRadius = 4
        currentAuthType = .faceId
        typeBView.layer.borderWidth = 2
        typeBView.layer.borderColor = UIColor.init(hex: "#76BBE7")?.cgColor
        typeAView.layer.borderWidth = 0
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if currentAuthType == .loginOlaaword {
            // push to next page
            let vc = InputOlaaViewController.instance()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            // face id
            FaceIdAuthHelper.shared.authenticate { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    // push view
                    print("success! push view!")
                    
                    // keychain
                    // let keychain = KeychainSwift()
                    // let memberAccount: String = keychain.get("memberAccount") ?? ""
                    // let olaaword: String = keychain.get("olaaword") ?? ""
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "AuthSetting", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AuthSettingStep1ViewController") as! AuthSettingStep1ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case .failure(let failure):
                    print("\(failure.localizedDescription)")
                }
            }
        }
    }
}

extension AuthTypeViewController {
    static func instance() -> AuthTypeViewController {
        let viewController = AuthTypeViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension AuthTypeViewController: LoginResultProtocol {
    func success(loginRspInfo: LoginRspModel?) {
        //
    }
    
    func error(errorCode: String, errorMessage: String) {
        //
    }
    
    func error(error: any Error) {
        //
    }
    
    func success(accessToken: String, user: MemberRspModel?) {
        //
    }
}
