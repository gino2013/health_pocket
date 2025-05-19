//
//  UIAlertControllerHelpers.swift
//  SDK
//
//  Created by Keneth on 2023/9/28.
//

import UIKit

extension UIAlertController {
    @discardableResult
    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction]) -> Bool {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach(alert.addAction)
        viewController.present(alert, animated: true, completion: nil)
        return true
    }
    
    @discardableResult
    static func present(
        in viewController: UIViewController,
        title: String?,
        textViewMessage: String?,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction]) -> Bool {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: style)
        alert.addTextField { textField in
            textField.text =  textViewMessage
        }
        actions.forEach(alert.addAction)
        viewController.present(alert, animated: true, completion: nil)
        return true
    }

    @discardableResult
    static func present(
        in viewController: UIViewController,
        error: Error,
        done: (() -> Void)? = nil) -> Bool {
        
        return present(
            in: viewController,
            title: "Error",
            message: "\(error.localizedDescription)",
            actions: [
                .init(title: "OK", style: .cancel) { _ in done?() }
            ]
        )
    }

    @discardableResult
    static func present(
        in viewController: UIViewController,
        error: String,
        done: (() -> Void)? = nil) -> Bool {
        
        return present(
            in: viewController,
            title: "Error",
            message: error,
            actions: [
                .init(title: "OK", style: .cancel) { _ in done?() }
            ]
        )
    }
    
    @discardableResult
    static func present(
        in viewController: UIViewController,
        successResult result: String,
        done: (() -> Void)? = nil) -> Bool {
        
        return present(
            in: viewController,
            title: "Success",
            message: result,
            actions: [
                .init(title: "OK", style: .default) { _ in done?() }
            ]
        )
    }
}
