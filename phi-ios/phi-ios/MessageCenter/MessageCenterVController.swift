//
//  MessageCenterVController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/6/24.
//

import UIKit

class MessageCenterVController: BaseViewController {
    
    @IBOutlet weak var phSegmentedControl: PHSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var personalMessageVController: UIViewController?
    var systemNotificationVController: UIViewController?
    var prePage: PreviousPage = .medicalHistory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        replaceBackBarButtonItem()
    }
    
    func updateUI() {
        let storyboard = UIStoryboard(name: "MessageCenter", bundle: nil)
        personalMessageVController = storyboard.instantiateViewController(withIdentifier: "PersonMessageVController")
        systemNotificationVController = storyboard.instantiateViewController(withIdentifier: "SystemNotifyVController")
        
        if let systemNotifyVC = systemNotificationVController as? SystemNotifyVController {
            systemNotifyVC.prePage = self.prePage
        }
    
        if let personalVC = personalMessageVController as? PersonMessageVController {
            personalVC.prePage = self.prePage
        }
        
        if let firstViewController = personalMessageVController {
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
        if let currentViewController = children.first {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
        }
        
        if index == 0, let viewController = personalMessageVController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        } else if index == 1, let viewController = systemNotificationVController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
}
