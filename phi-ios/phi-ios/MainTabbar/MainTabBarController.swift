//
//  MainTabBarController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/1/30.
//

import UIKit
import Foundation

class CustomTabBar: UITabBar {
    private let customHeight: CGFloat = 98 // 设置新的高度 (34+64)
    
    func isIPhoneSE() -> Bool {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let isSmallScreen = (screenHeight == 568.0 || screenHeight == 667.0) && screenWidth == 320.0
        let isThirdGenSE = (screenHeight == 667.0 && screenWidth == 375.0) && UIDevice.current.userInterfaceIdiom == .phone
        
        // iPhone SE (1st generation) has a screen height of 568 points
        // iPhone SE (2nd and 3rd generation) has a screen height of 667 points but the width remains the same for SE
        return isSmallScreen || isThirdGenSE
    }
    
    override func layoutSubviews() {
        var tabBarFrame = self.frame
        
        if isIPhoneSE() {
            tabBarFrame.size.height = 64
            tabBarFrame.origin.y = self.superview!.frame.size.height - 64
        } else {
            tabBarFrame.size.height = customHeight
            tabBarFrame.origin.y = self.superview!.frame.size.height - customHeight
        }
        
        self.frame = tabBarFrame
        super.layoutSubviews()
    }
}

class MainTabBarController: UITabBarController {
    var viewModel: TabbarViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.logoutUser),
            name: .appLogout,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    private func makeNav(for vc: UIViewController, title: String, icon: String) -> UIViewController {
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(
            systemName: icon,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        nav.tabBarItem.title = title
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    @objc func logoutUser() {
        PHISDK_AllResponseData.sharedInstance = PHISDK_AllResponseData()
        SharingManager.sharedInstance = SharingManager()
        self.viewModel?.deleteDataAndLogout()
    }
}
