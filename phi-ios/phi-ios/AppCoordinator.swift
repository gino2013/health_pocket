//
//  AppCoordinator.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import Foundation
import UIKit

// Startup app should consist of multiple coordinators, one for each scene.
// But it should always have one “main” AppCoordinator, which will be owned by the App delegate.

class AppCoordinator: BaseCoordinator {
    let window: UIWindow?
    lazy var rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        if PHISDK_AllResponseData.sharedInstance.loginStatus {
            tabbarFlow()
            
            /*
            if let user = PHISDK_AllResponseData.sharedInstance.userInfo {
                tabbarFlow()
                
                /*
                if PHISDK_AllResponseData.sharedInstance.appIsLive {
                    //tabbarFlow(with: user)
                } else {
                    //dashboardFlow(with: user)
                }
                 */
            }
            */
        } else {
            loginFlow()
        }
    }
    
    private func loginFlow() {
        let loginCoordinator = LoginCoordinator(navigationcontroller: self.rootViewController)
        loginCoordinator.delegate = self
        store(coordinator: loginCoordinator)
        loginCoordinator.start()
    }
    
    
    private func reloginFlow() {
        let loginCoordinator = LoginCoordinator(navigationcontroller: self.rootViewController)
        loginCoordinator.delegate = self
        store(coordinator: loginCoordinator)
        loginCoordinator.logoutStart()
    }
    
    /*
    private func dashboardFlow(with userProfile: UserProfile) {
        let dashboardCoordinator = DashboardCoordinator(navigationcontroller: self.rootViewController, with: userProfile)
        dashboardCoordinator.delegate = self
        store(coordinator: dashboardCoordinator)
        dashboardCoordinator.start()
    }
    
    private func profileFlow(with userProfile: PHI_SDK.UserProfile) {
        let profileCoordinator = ProfileCoordinator(navigationcontroller: self.rootViewController, with: userProfile)
        profileCoordinator.delegate = self
        store(coordinator: profileCoordinator)
        profileCoordinator.start()
    }
    */
    
    private func tabbarFlow() {
        let tabbarCoordinator = TabbarCoordinator(navigationcontroller: self.rootViewController)
        tabbarCoordinator.delegate = self
        store(coordinator: tabbarCoordinator)
        tabbarCoordinator.start()
    }
    
    /*
    private func tabbarFlow(with userModel: UserModel?) {
        let tabbarCoordinator = TabbarCoordinator(navigationcontroller: self.rootViewController, with: userModel)
        tabbarCoordinator.delegate = self
        store(coordinator: tabbarCoordinator)
        tabbarCoordinator.start()
    }
     */
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func didFinishLoginCordinator(coordinator: any Coordinator) {
        self.free(coordinator: coordinator)
        //self.tabbarFlow(with: userModel)
        self.tabbarFlow()
    }
    
    func didFinishLoginCordinator(coordinator: Coordinator, with userModel: MemberRspModel?) {
        self.free(coordinator: coordinator)
        self.tabbarFlow()
        /*
        if PHISDK_AllResponseData.sharedInstance.appIsLive {
            //self.tabbarFlow(with: userProfile)
        } else {
            //self.dashboardFlow(with: userProfile)
        }
         */
    }
}

extension AppCoordinator: TabbarCoordinatorDelegate {
    func didFinishTabbarCordinator(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
        //self.loginFlow()
        self.reloginFlow()
    }
}

/*
extension AppCoordinator: DashboardCoordinatorDelegate {
    func didFinishDashboardCordinator(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
        self.loginFlow()
    }
}

extension AppCoordinator: ProfileCoordinatorDelegate {
    func didFinishProfileCordinator(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
        self.loginFlow()
    }
}
*/
