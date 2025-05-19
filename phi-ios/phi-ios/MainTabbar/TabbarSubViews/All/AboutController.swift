//
//  AboutController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/9/3.
//

import UIKit
import Lottie
import PanModal
import SwiftUI

class AboutController: BaseViewController {
    
    @IBOutlet weak var aboutInfoTopView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var progressBarContainer: UIView!
    @IBOutlet weak var lightningContainer: UIView!
    @IBOutlet weak var testButton: UIButton!
    
    var progressBarView: LottieAnimationView? // 用來持有進度條動畫
    var lightningView: LottieAnimationView? // 用來持有閃電動畫
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        //lottieAnimationDemo()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateUI() {
        aboutInfoTopView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        versionLabel.text = "V \(version ?? "N/A") (Build: \(build ?? "N/A"))"
    }
    
    // 每次打開菜單時動態生成
    func createMenu() -> UIMenu {
        return DropdownUIMenuUtils.createDropdownMenu(selectedOptionKey: "SportFreqSelection") { selectedOption in
            print("用戶選擇了 \(selectedOption.title)")
            
            // 選擇後立即重建菜單，確保下次打開時預設選項正確
            self.testButton.menu = self.createMenu()
            
            if selectedOption == .sportTarget {
                let storyboard = UIStoryboard(name: "SportsTarget", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddSportTargetVC") as! AddSportTargetVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if selectedOption == .speechDemo {
                // 創建 StepCountViewController 的實例
                // let stepCountVC = StepCountViewController()
                // let stepCountVC = HealthDataViewController()
                // let stepCountVC = BleTestViewController()
                let stepCountVC = SpeechViewController()
                stepCountVC.hidesBottomBarWhenPushed = true
                // 將 StepCountViewController 推送到導航控制器
                self.navigationController?.pushViewController(stepCountVC, animated: true)
            } else if selectedOption == .sportInfo {
                let storyboard = UIStoryboard(name: "SportSetting", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SportSettingViewController") as! SportSettingViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if selectedOption == .signPDF {
                let storyboard = UIStoryboard(name: "Signature", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if selectedOption == .googleAIDemo {
                let gAIVC = GoogleAIViewController()
                gAIVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(gAIVC, animated: true)
            } else if selectedOption == .resetReminderSetting {
                // reset reminder setting
                UserDefaults.standard.clearWorkAndRestTimeSettings()
                UserDefaults.standard.clearReminderTimeSetting()
            } else if selectedOption == .SwiftUI {
                // 使用 UIHostingController 將 SwiftUI View 包裝到 UIKit ViewController
                let swiftUIView = SUViewController() // SwiftUI 的 View
                let hostingController = UIHostingController(rootView: swiftUIView)
                
                // 跳轉到 SwiftUI View
                self.navigationController?.pushViewController(hostingController, animated: true)
            }
        }
    }
    
    func setupMenu() {
        // 確保按鈕在被點擊時顯示菜單
        testButton.showsMenuAsPrimaryAction = true
        
        // 使用 menu 的 getter，每次點擊按鈕時重建菜單
        testButton.menu = createMenu()
    }
    
    func lottieAnimationDemo() {
        // 使用 LottieUtils 設置進度條動畫，將其附加到 progressBarContainer 上
        progressBarView = LottieUtils.setupProgressBar(
            in: self.progressBarContainer,
            animationName: "Lottie_Progress",
            startProgress: 0.0,
            endProgress: 0.78
        ) {
            print("Progress bar animation finished at 78%")
        }
        
        // 使用 LottieUtils 設置閃電動畫，並將其附加到 lightningContainer 上
        lightningView = LottieUtils.setupLoopingAnimation(
            in: self.lightningContainer,
            animationName: "Lottie_Lightning"
        )
    }
    
    func testLottieAnimation() {
        /*
        let storyboard = UIStoryboard(name: "AllFunc", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
        */
        
        /*
        let vc = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        */
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func testShowPdf() {
        let storyboard = UIStoryboard(name: "AllFunc", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RemotePDFViewController") as! RemotePDFViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        // testLottieAnimation()
    }
    
    @IBAction func testPDFAction(_ sender: Any) {
        // testShowPdf()
        // 使用 PanModal 展示面板
        /*
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let contentVC = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        presentPanModal(contentVC)
        */
         
        testLottieAnimation()
    }
    
    @IBAction func testBleFunction(_ sender: UIButton) {
        let stepCountVC = BleTest2ViewController()
        stepCountVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(stepCountVC, animated: true)
    }
}
