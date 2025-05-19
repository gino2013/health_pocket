//
//  CalcResultViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/9.
//

import UIKit
import WebKit
import ProgressHUD

class CalcResultViewController: BaseViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var pdfUrl: String = "https://drive.google.com/file/d/1xA8lwS7GWit0S7GNhV2KpmgxApzqYZLN/view"
      
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        
        // 初始化 WKWebView
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // 使用 Auto Layout 設定 WebView 的佈局
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //  URL 編碼問題
        //  URL 中包含了中文（如 術前理賠試算報告）。在 Swift 中，URL(string:) 方法對 URL 的格式要求嚴格，對於包含非 ASCII 字元的 URL 可能會判斷為無效。可以試試將 URL 做百分比編碼。
        if let encodedUrl = pdfUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("無效的 URL")
        }
        
        /*
        // 載入遠端 PDF 檔案
        if let url = URL(string: pdfUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("無效的 URL")
        }
        */
        
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
