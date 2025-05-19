//
//  LivingHabitNavigationController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/7.
//

import UIKit

class LivingHabitNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 從 Storyboard 加載 DDDViewController
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dddViewController = storyboard.instantiateViewController(withIdentifier: "DDDViewController") {
            
            // 設置 rootViewController 為 DDD ViewController
            self.setViewControllers([dddViewController], animated: false)
        }
        */
    
        let vc = LivingHabitsViewController.instance()
        self.setViewControllers([vc], animated: false)        
    }
}
