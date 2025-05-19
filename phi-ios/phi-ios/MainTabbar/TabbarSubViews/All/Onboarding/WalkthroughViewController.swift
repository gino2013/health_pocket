//
//  WalkthroughViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/10.
//

import UIKit
import Lottie

class WalkthroughViewController: BaseViewController {
    
    @IBOutlet weak var lottieView: UIView!
    
    var medicationRemindeGuideView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        lottieAnimationDemo()
    }
    
    func lottieAnimationDemo() {
        // 使用 LottieUtils 設置動畫，並將其附加到 lottieView 上
        // lottieView.contentMode = .scaleAspectFit
        lottieView = LottieUtils.setupLoopingAnimation(
            in: self.lottieView,
            animationName: "MedReminderGuide_1"
        )
    }
}
