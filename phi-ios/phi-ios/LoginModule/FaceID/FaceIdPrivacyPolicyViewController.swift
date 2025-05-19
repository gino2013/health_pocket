//
//  FaceIdPrivacyPolicyViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/18.
//

import UIKit

enum FaceIdPrivacyPresentType: Int {
    case mainMenu
    case allFunctionMenu
}

protocol FaceIdPrivacyPolicyVCDelegate: AnyObject {
    func showSettingFaceIdAlert()
    func showSettingSuccessAlert()
}

class FaceIdPrivacyPolicyViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectFaceIdPrivacy: SelectPrivacy!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var gIsCheckBoxEnable: Bool = false
    weak var delegate: FaceIdPrivacyPolicyVCDelegate?
    var currentFaceIdPrivacyPresentType: FaceIdPrivacyPresentType = .mainMenu
    
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
            // dismiss(animated: true, completion: nil)
            
            if viewTranslation.y < 200 {
                /*
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
                 */
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        default:
            break
        }
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // check user enable faceID or not
        FaceIdAuthHelper.shared.askBiometricAvailability { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Status: \n" + error.localizedDescription)
                self.delegate?.showSettingFaceIdAlert()
            } else {
                self.delegate?.showSettingSuccessAlert()
            }
        }
    }
}

extension FaceIdPrivacyPolicyViewController {
    func updateUI() {
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        scrollView.delegate = self
        
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        selectFaceIdPrivacy.firstLabel.text = "我已閱畢，並同意上述聲明"
        selectFaceIdPrivacy.secondLabel.isHidden = true
        selectFaceIdPrivacy.secondLabelButton.isHidden = true
        selectFaceIdPrivacy.delegate = self
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
    }
}

extension FaceIdPrivacyPolicyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension FaceIdPrivacyPolicyViewController: SelectPrivacyDelegate {
    func presetPrivacyPolicy(sender: UIButton) {
        // N/A
    }
    
    func checkBoxStatus(isSelect: Bool) {
        self.gIsCheckBoxEnable = isSelect
        
        nextButton.isEnabled = gIsCheckBoxEnable
        
        if gIsCheckBoxEnable {
            nextButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        } else {
            nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        }
    }
}
