//
//  OnboardingPageViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/12/2.
//

import UIKit
import Lottie

class OnboardingPageViewController: BaseViewController {
    
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var titleLabel: UILabel!            // 標題
    @IBOutlet weak var descriptionLabel: UILabel!      // 描述
    @IBOutlet weak var completeButton: UIButton!       // 完成按鈕（僅最後一頁顯示）

    var medicationRemindeGuideView: LottieAnimationView?
    var titleText: String = ""
    var onComplete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        //lottieAnimationDemo()
    }
    
    func lottieAnimationDemo(animationName: String) {
        // 使用 LottieUtils 設置動畫，並將其附加到 lottieView 上
        // lottieView.contentMode = .scaleAspectFit
        lottieView = LottieUtils.setupLoopingAnimation(
            in: self.lottieView,
            animationName: animationName
        )
    }
    
    func configure(with content: (image: String, title: String, description: String), at isLastPage: Bool) {
        // imageView.image = UIImage(named: content.image)
        lottieAnimationDemo(animationName: content.image)
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        titleText = content.title
        completeButton.isHidden = !isLastPage
    }
    
    @IBAction func didTapComplete(_ sender: UIButton) {
        onComplete?()
    }
}
