//
//  RemotePDFViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/9.
//

import UIKit
import WebKit
import ProgressHUD

class RemotePDFViewController: BaseViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var pdfUrl: String = "https://drive.google.com/file/d/1xA8lwS7GWit0S7GNhV2KpmgxApzqYZLN/view"
      
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        
        // 初始化 WKWebView
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        // 載入遠端 PDF 檔案
        if let url = URL(string: pdfUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("無效的 URL")
        }
        
        // 加載本地 PDF 檔案
        /*
        if let pdfPath = Bundle.main.path(forResource: "sample", ofType: "pdf") {
            let url = URL(fileURLWithPath: pdfPath)
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("找不到 PDF 檔案")
        }
        */
    }
    
    // 當 PDF 開始加載時，顯示活動指示器
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
    }
    
    // 當 PDF 加載完成時，隱藏活動指示器
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    // 如果加載失敗，也隱藏活動指示器
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        print("PDF 加載失敗: \(error.localizedDescription)")
    }
}
