//
//  TabbarCoordinator.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/10/26.
//

import UIKit

public protocol TabbarCoordinatorDelegate: AnyObject {
    func didFinishTabbarCordinator(coordinator: Coordinator)
}

class TabbarCoordinator: BaseCoordinator {
    private let navigationcontroller: UINavigationController
    public weak var delegate: TabbarCoordinatorDelegate?
    //private let userModel: UserModel?
    
    lazy var mainTabBarController: MainTabBarController? = {
        //let controller = MainTabBarController()
        //return controller
        
        let controller = UIStoryboard(name: "MainTabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
        let viewModel = TabbarViewModel()
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinatorDelegate = self
        return controller
    }()
    
    init(navigationcontroller: UINavigationController) {
        self.navigationcontroller = navigationcontroller
    }
    
    /*
    init(navigationcontroller: UINavigationController, with userModel: UserModel?) {
        self.navigationcontroller = navigationcontroller
        self.userModel = userModel
    }
    */
    
    override func start() {
        if let controller = self.mainTabBarController {
            //self.navigationcontroller.setViewControllers([controller], animated: false)
            switchRootViewController(rootViewController: controller, animated: true, completion: nil)
        }
        
        /*
         if let controller = self.mainTabBarController {
         let viewC = controller.viewControllers?.first
         
         if let nav = viewC as? UINavigationController {
         let visible: ProfileViewController = nav.visibleViewController as! ProfileViewController
         
         visible.viewModel?.tabbarViewModelCoordinatorlDelegate = self
         }
         
         self.navigationcontroller.setViewControllers([controller], animated: false)
         }
         */
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        /*
         if let keyWindow = UIApplication.shared.connectedScenes
         .filter({$0.activationState == .foregroundActive})
         .compactMap({$0 as? UIWindowScene})
         .first?.windows
         .filter({$0.isKeyWindow}).first {
         
         if animated {
         UIView.transition(with: keyWindow, duration: 0.6, options: .transitionCrossDissolve, animations: {
         let oldState: Bool = UIView.areAnimationsEnabled
         UIView.setAnimationsEnabled(false)
         keyWindow.rootViewController = rootViewController
         UIView.setAnimationsEnabled(oldState)
         }, completion: { (finished: Bool) -> () in
         if (completion != nil) {
         completion!()
         }
         })
         } else {
         keyWindow.rootViewController = rootViewController
         }
         }
         */
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

extension TabbarCoordinator: TabbarViewModelCoordinatorlDelegate {
    func logout() {
        self.delegate?.didFinishTabbarCordinator(coordinator: self)
    }
}
