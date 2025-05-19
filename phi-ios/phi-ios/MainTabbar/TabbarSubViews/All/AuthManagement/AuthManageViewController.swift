//
//  AuthManageViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/10.
//

import UIKit

class AuthManageViewController: BaseViewController {
    
    @IBOutlet weak var phSegmentedControl: PHSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var medicalInfoAuthViewController: UIViewController?
    var otherAuthViewController: UIViewController?
    var needBackToRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func createRightBarButton() {
        let titleLabel = UILabel()
        titleLabel.text = "新增授權"
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
    
    func updateUI() {
        createRightBarButton()
        
        let storyboard = UIStoryboard(name: "AuthManagement", bundle: nil)
        medicalInfoAuthViewController = storyboard.instantiateViewController(withIdentifier: "MedicalAuthVController")
        otherAuthViewController = storyboard.instantiateViewController(withIdentifier: "OtherAuthVController")
        
        // 顯示初始視圖控制器（例如A）
        if let firstViewController = medicalInfoAuthViewController {
            addChild(firstViewController)
            firstViewController.view.frame = containerView.bounds
            containerView.addSubview(firstViewController.view)
            firstViewController.didMove(toParent: self)
        }
        
        phSegmentedControl.didTapSegment = { index in
            print(index)
            self.displayViewController(atIndex: index)
        }
    }
    
    func displayViewController(atIndex index: Int) {
        // 移除現有的子視圖控制器
        if let currentViewController = children.first {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
        }
        
        // 根據分段控制器的選擇，顯示對應的視圖控制器
        if index == 0, let viewController = medicalInfoAuthViewController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        } else if index == 1, let viewController = otherAuthViewController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    
    @objc func customBarButtonTapped() {
        processAddMedialAuth()
    }
    
    func processAddMedialAuth() {
        let storyboard = UIStoryboard(name: "Hospital", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HospitalListViewController") as! HospitalListViewController
        SharingManager.sharedInstance.currentAuthType = .addAuthorization
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc override func popPresentedViewController() {
        if needBackToRoot {
            needBackToRoot = false
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
