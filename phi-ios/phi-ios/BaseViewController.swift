//
//  BaseViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/10/26.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /*
        let presentButtonTitle = (self.presentingViewController == nil) ? "Present" : "Dismiss"
        let presentBarButtonItem = UIBarButtonItem(title: presentButtonTitle,
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(presentAction(_:)))
        */
        /*
        let settingsBarButtongItem = UIBarButtonItem(image: UIImage(named: "settings"),
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(settingsAction(_:)))
         */
        //self.navigationItem.rightBarButtonItems = [settingsBarButtongItem, presentBarButtonItem]
        //self.navigationItem.rightBarButtonItems = [presentBarButtonItem]
    }
    
    func showOfflinePage() -> Void {
        /*
        guard let vc = self.storyboard?.instantiateViewController(identifier: "OfflineViewController") as? OfflineViewController else { return  }
        self.presentOnRoot(with: vc, embedNavController: false)
         */
        print("Show Offline View Controller!")
    }
    
    func dismissOfflinePage() -> Void {
        self.dismiss(animated: true) {
            print("Offline View Controller removed!")
        }
    }
}

extension BaseViewController {

    @IBAction private func presentAction(_ sender: UIBarButtonItem) {

        if self.presentingViewController == nil {

            let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.popoverPresentationController?.barButtonItem = sender

            controller.addAction(.init(title: "Full Screen", style: .default, handler: { _ in
                self.presentUsing(style: .fullScreen /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Page Sheet", style: .default, handler: { _ in
                self.presentUsing(style: .pageSheet /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Form Sheet", style: .default, handler: { _ in
                self.presentUsing(style: .formSheet /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Current Context", style: .default, handler: { _ in
                self.presentUsing(style: .currentContext /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Over Full Screen", style: .default, handler: { _ in
                self.presentUsing(style: .overFullScreen /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Over Current Context", style: .default, handler: { _ in
                self.presentUsing(style: .overCurrentContext /*, sender: sender*/ )
            }))

            controller.addAction(.init(title: "Popover", style: .default, handler: { _ in
                self.presentUsing(style: .popover /*, sender: sender*/ )
            }))

            if #available(iOS 13, *) {
                controller.addAction(.init(title: "Automatic", style: .default, handler: { _ in
                    self.presentUsing(style: .automatic /*, sender: sender*/ )
                }))
            }

            controller.addAction(.init(title: "Cancel", style: .cancel))

            present(controller, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func presentUsing(style: UIModalPresentationStyle /*, sender: UIBarButtonItem*/ ) {

        let classNameString: String = "\(type(of: self.self))"

        let controller: UIViewController = (storyboard?.instantiateViewController(withIdentifier: classNameString))!
        let navController: NavigationController = NavigationController(rootViewController: controller)
        navController.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        navController.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        navController.navigationBar.titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
        navController.modalPresentationStyle = style
        /*
        if style == .popover {
            let heightWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            navController.preferredContentSize = CGSize(width: heightWidth, height: heightWidth)
            navController.popoverPresentationController?.barButtonItem = sender
            navController.popoverPresentationController?.delegate = self
        }
        */
        present(navController, animated: true, completion: nil)
    }
}

/*
extension BaseViewController {
    @IBAction private func settingsAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")

        let navController: NavigationController = NavigationController(rootViewController: controller)
        navController.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        navController.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        navController.navigationBar.titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
        navController.modalPresentationStyle = .popover
        navController.popoverPresentationController?.barButtonItem = sender
        let heightWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        navController.preferredContentSize = CGSize(width: heightWidth, height: heightWidth)
        navController.popoverPresentationController?.delegate = self
        present(navController, animated: true, completion: nil)
    }
}
*/

extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.endEditing(true)
    }
}

extension BaseViewController {
    @objc func popPresentedViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func replaceBackBarButtonItem(selector: Selector? = nil) {
        guard let backImage = UIImage(named: "Nav_control") else {
            return
        }
        
        guard let highlightedImage = UIImage(named: "Nav_control") else {
            return
        }
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height))
        backButton.setTitle("      ", for: .normal)
        backButton.setImage(backImage, for: UIControl.State())
        backButton.setImage(highlightedImage, for: .highlighted)
        
        if selector == nil {
            backButton.addTarget(self, action: #selector(self.popPresentedViewController), for: .touchUpInside)
        } else {
            backButton.addTarget(self, action: selector!, for: .touchUpInside)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func rightBarButtonTapped() {
        let message = "此功能尚未開放，敬請期待"
        let alert = UIAlertController(title: "提醒",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createRightBarButtonViaImage(imageName: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(self.rightBarButtonTapped), for: .touchUpInside)
        
        let customBarButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = customBarButton
    }
}
