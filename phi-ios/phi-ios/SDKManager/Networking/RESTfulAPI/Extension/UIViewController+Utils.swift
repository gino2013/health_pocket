//
//  UIViewController+Utils.swift
//  SDK
//
//  Created by Kenneth on 2023/11/02.
//

import UIKit

extension UIViewController {
    public var foregroundViewController: UIViewController {
        if let controller = presentedViewController {
            return controller.foregroundViewController
        }
        return self
    }
    
    func presentOnRoot(with viewController: UIViewController, embedNavController: Bool) {
        var presentVC = viewController
        
        if embedNavController {
            presentVC = UINavigationController(rootViewController: viewController)
        }
        
        presentVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(presentVC, animated: false, completion: nil)
    }
    
    private func showLogoutAlert() {
        DispatchQueue.main.async {
            let alertViewController = UINib(nibName: "LogoutAlertVC", bundle: nil)
                .instantiate(withOwner: nil, options: nil)
                .first as! LogoutAlertVC
            alertViewController.alertLabel.text = "無法取得Id-Token"
            alertViewController.delegate = self
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func handleAPIError<T>(
        response: PhiResponseModel<T>,
        retryAction: @escaping () -> Void,
        fallbackAction: @escaping () -> Void
    ) {
        guard let errorCode = response.errorCode else {
            fallbackAction()
            return
        }
        
        if errorCode == "B002" || errorCode == "B001" {
            RefreshAPITokenUtils.shared.refreshApiToken { success in
                if success {
                    // Token 刷新成功，重試 API
                    retryAction()
                } else {
                    // Token 刷新失敗，顯示登出提示
                    self.showLogoutAlert()
                }
            }
        } else {
            // 其他錯誤，直接執行後備行動
            fallbackAction()
        }
    }
}

extension UIViewController: LogoutAlertVCDelegate {
    func clickThenLogout() {
        NotificationCenter.default.post(
            name: .appLogout,
            object: self,
            userInfo: nil)
    }
}
