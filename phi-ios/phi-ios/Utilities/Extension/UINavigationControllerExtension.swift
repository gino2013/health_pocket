//
//  UINavigationControllerExtension.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/27.
//

import Foundation
import UIKit

/// `UINavigationController` 的擴展，提供了帶有完成回調的導航操作方法。
public extension UINavigationController {
    
    /// 彈出頂層的視圖控制器，並在彈出動畫完成後執行給定的回調。
    ///
    /// - Parameter completion: 可選的回調閉包，當彈出動畫完成後執行。默認為 `nil`。
    func popViewController(_ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    /// 推入新的視圖控制器，並在推入動畫完成後執行給定的回調。
    ///
    /// - Parameters:
    ///   - viewController: 要推入的視圖控制器。
    ///   - completion: 可選的回調閉包，當推入動畫完成後執行。默認為 `nil`。
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// 彈出所有視圖控制器，返回到根視圖控制器，並在彈出動畫完成後執行給定的回調。
    ///
    /// - Parameter completion: 可選的回調閉包，當彈出動畫完成後執行。默認為 `nil`。
    func popToRootViewController(_ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: true)
        CATransaction.commit()
    }
    
    /// 彈出所有視圖控制器，返回到根視圖控制器，並在動畫禁用的情況下執行給定的回調。
    ///
    /// - Parameter completion: 可選的回調閉包，當彈出操作完成後執行。默認為 `nil`。
    func popToRootViewControllerDisableAnimate(_ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: false)
        CATransaction.commit()
    }
}
