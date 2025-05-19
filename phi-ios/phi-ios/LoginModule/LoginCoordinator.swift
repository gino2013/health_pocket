//
//  LoginCoordinator.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func didFinishLoginCordinator(coordinator: Coordinator, with userModel: MemberRspModel?)
    func didFinishLoginCordinator(coordinator: Coordinator)
}

// LoginCoordinator handles the responsibility if naviagtion in login-module
final class LoginCoordinator: BaseCoordinator {
    private let navigationcontroller: UINavigationController
    public weak var delegate: LoginCoordinatorDelegate?
    
    init(navigationcontroller: UINavigationController) {
        self.navigationcontroller = navigationcontroller
    }
    
    override func start() {
        if let controller = self.loginController {
            self.navigationcontroller.setViewControllers([controller], animated: false)
        }
    }
    
    func logoutStart() {
        if let controller = self.loginController {
            self.navigationcontroller.setViewControllers([controller], animated: false)
        }
        switchRootViewController(rootViewController: self.navigationcontroller, animated: true, completion: nil)
    }
    
    // init login view controller
    lazy var loginController: LoginViewController? = {
        let viewModel = LoginViewModel()
        viewModel.coordinatorDelegate = self
        
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        controller?.viewModel = viewModel
        return controller
    }()
    
    // init register view controller
    lazy var registerViewController: RegisterViewController? = {
        let controller = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        return controller
    }()
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        if animated {
            UIView.transition(with: window, duration: 0.6, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}

extension LoginCoordinator: LoginViewModelCoordinatorDelegate {
    func loginDidSuccess() {
        self.delegate?.didFinishLoginCordinator(coordinator: self)
    }
    
    func didTapFirstView() {
        //
    }
    
    func didTapSecondView() {
        //
    }
    
    func didTapThirdView() {
        //
    }
    
    func loginDidSuccess(with userModel: MemberRspModel?) {
        self.delegate?.didFinishLoginCordinator(coordinator: self, with: userModel)
    }
    
    func loginFailed(errorCode: String, errorMessage: String) {
        //self.loginController?.displayAlertMessage(errorCode: errorCode, errorMessage: errorMessage)
    }
}
