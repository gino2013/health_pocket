//
//  LoginViewModel.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/10/26.
//

import Foundation

protocol LoginViewModelCoordinatorDelegate: AnyObject {
    //func loginDidSuccess(with response: UserModel?)
    func loginDidSuccess()
    func loginFailed(errorCode: String, errorMessage: String)
    
}

protocol LoginFunctionProtocol {
    // func login(username: String?, olaaword: String?, uuid: String?)
    func sendLogin(username: String?, olaaword: String?, uuid: String?)
}

protocol LoginResultProtocol: AnyObject {
    // Firebase Login Test
    // func success(accessToken: String, user: UserModel?)
    // func error(error: Error)
    
    // PHI Login
    func success(loginRspInfo: LoginRspModel?)
    func error(errorCode: String, errorMessage: String)
}

class LoginViewModel: LoginFunctionProtocol {
    var user: MemberRspModel?
    var token: String?
    public weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    weak var delegate: LoginResultProtocol?
    
    func sendLogin(username: String?, olaaword: String?, uuid: String?) {
        guard let username = username,
              let olaaword = olaaword,
              let uuid = uuid  else {
            return
        }
        
        let rsaOlaaword = RsaUtils.generateEncryptedData(src: olaaword)
        
        let loginInfo: LoginModel = LoginModel(memberAccount: username, memberKeycode: rsaOlaaword, mobileUuid: uuid)
        
        SDKManager.sdk.requestLogin(loginInfo) {
            (responseModel: PhiResponseModel<LoginRspModel>) in
            
            if responseModel.success {
                guard let logRspInfo = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    self.delegate?.success(loginRspInfo: logRspInfo)
                })
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                DispatchQueue.main.async(execute: {
                    self.delegate?.error(errorCode: responseModel.errorCode ?? "", errorMessage: responseModel.message ?? "")
                })
            }
        }
    }
}
