//
//  PrivacyPolicyViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/18.
//

import UIKit

class PrivacyPolicyViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(handleDismiss)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        UIView.animate(withDuration: 0.33) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.76)
        }
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.view.backgroundColor = .clear
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        //self.dismiss(animated: true, completion: nil)
        
        switch sender.state {
        //case .changed:
            /*
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
             */
        case .ended:
            dismiss(animated: true, completion: nil)
            /*
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
             */
        default:
            break
        }
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PrivacyPolicyViewController {
    func updateUI() {
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        scrollView.delegate = self
    }
}

extension PrivacyPolicyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
