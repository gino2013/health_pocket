//
//  DataViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/12/3.
//

import UIKit
import Lottie

class DataViewController: BaseViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var onboardingPagaControl: UIPageControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    var dataObject: OnboardingData = OnboardingData.page1
    var medicationRemindeGuideView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.dataLabel!.text = dataObject.pageTitle
        lottieAnimationDemo(dataObject: dataObject.lottieName)
        configurePageControl()
        textView.attributedText = createAttributedText(title: dataObject.pageTitle,
                                                       body: dataObject.pageContent)
        configureButtonBottomView()
    }
    
    func currentPageIndex(for page: OnboardingData) -> Int {
        guard let index = OnboardingData.allCases.firstIndex(of: page) else { return 0 }
        return index
    }
    
    func configurePageControl() {
        onboardingPagaControl.numberOfPages = OnboardingData.allCases.count
        onboardingPagaControl.currentPage = currentPageIndex(for: dataObject)
        // 其他頁面顏色
        onboardingPagaControl.pageIndicatorTintColor = UIColor(hex: "#C0DFF4")
        // 當前頁面顏色
        onboardingPagaControl.currentPageIndicatorTintColor = UIColor(hex: "#3399DB")
        onboardingPagaControl.isUserInteractionEnabled = false
    }
    
    func lottieAnimationDemo(dataObject: String) {
        // 使用 LottieUtils 設置動畫，並將其附加到 lottieView 上
        // lottieView.contentMode = .scaleAspectFit
        lottieView = LottieUtils.setupLoopingAnimation(
            in: self.lottieView,
            animationName: dataObject
        )
    }
    
    func configureButtonBottomView() {
        if currentPageIndex(for: dataObject) == (OnboardingData.allCases.count-1) {
            buttonContainerView.isHidden = false
            lineView.isHidden = false
            view.backgroundColor = .white
        } else {
            buttonContainerView.isHidden = true
            lineView.isHidden = true
            view.backgroundColor = UIColor(hex: "#FAFAFA")
        }
    }
    
    @IBAction func completeTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DataViewController {
    func createAttributedText(title: String, body: String) -> NSAttributedString {
        // 創建富文本樣式
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium), // 標題字型
            .foregroundColor: UIColor(hex: "#34393D")! // 標題顏色
        ]
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular), // 內文字型
            .foregroundColor: UIColor(hex: "#858585")! // 內文顏色
        ]
        
        // 段距設定
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2 // 行距
        
        let spacerAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        
        // 組合富文本
        let attributedTitle = NSAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let attributedSpacer = NSAttributedString(string: "\n", attributes: spacerAttributes)
        let attributedBody = NSAttributedString(string: body, attributes: bodyAttributes)
        
        // 組合標題和內文
        let combinedText = NSMutableAttributedString()
        combinedText.append(attributedTitle)
        combinedText.append(attributedSpacer)
        combinedText.append(attributedBody)
        
        return combinedText
    }
}
