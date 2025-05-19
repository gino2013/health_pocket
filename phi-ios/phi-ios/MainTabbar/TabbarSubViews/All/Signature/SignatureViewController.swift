//
//  SignatureViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/11/5.
//

import UIKit
import PDFKit

/// 使用 PDFKit 將簽名嵌入到 PDF 的特定位子
/// - Parameters:
///   - pdfURL: 現有 PDF 文件的路徑
///   - signatureImage: 簽名圖片 (UIImage)
///   - pageIndex: 要嵌入簽名的頁面索引（從 0 開始）
///   - signatureSize: 簽名的大小（以點為單位，CGSize）
///   - offset: 簽名的位置偏移（以點為單位，CGPoint）
///   - outputURL: 輸出修改後的 PDF 文件路徑

// 統一的方向性調整函數
func adjustSignatureOffset(
    rotation: Int,
    offset: CGPoint,
    signatureSize: CGSize,
    pageBounds: CGRect
) -> CGPoint {
    switch rotation {
    case 90:  // 順時針旋轉90度
        return CGPoint(
            x: pageBounds.height - offset.y - signatureSize.height,
            y: offset.x
        )
    case 180:  // 旋轉180度
        return CGPoint(
            x: pageBounds.width - offset.x - signatureSize.width,
            y: pageBounds.height - offset.y - signatureSize.height
        )
    case 270:  // 逆時針旋轉90度
        return CGPoint(
            x: offset.y,
            y: pageBounds.width - offset.x - signatureSize.width
        )
    default:   // 0度，無旋轉
        return offset
    }
}

// 更靈活的圖片旋轉函數
func rotateImage(_ image: UIImage, degrees: CGFloat) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: image.size)
    return renderer.image { context in
        let cgContext = context.cgContext
        
        // 移動到中心點，進行旋轉
        cgContext.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        cgContext.rotate(by: degrees * .pi / 180) // 彈性旋轉角度
        cgContext.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        
        // 繪製圖片
        image.draw(at: .zero)
    }
}

func embedSignatureWithPDFKit(
    pdfURL: URL,
    signatureImage: UIImage,
    pageIndex: Int,
    signatureSize: CGSize,
    offset: CGPoint,
    outputURL: URL
) {
    // 1. 檢查並刪除舊的輸出文件
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: outputURL.path) {
        do {
            try fileManager.removeItem(at: outputURL)
            print("✅ 舊的 SignedSportSign.pdf 已刪除")
        } catch {
            print("❌ 無法刪除舊文件: \(error)")
        }
    }
    
    // 2. 加載 PDF 文件
    guard let pdfDocument = PDFDocument(url: pdfURL) else {
        print("❌ 無法加載 PDF 文件: \(pdfURL)")
        return
    }
    
    // 3. 確認指定頁面是否存在
    guard let page = pdfDocument.page(at: pageIndex) else {
        print("❌ 頁面 \(pageIndex + 1) 不存在")
        return
    }
    
    // 4. 取得頁面尺寸與旋轉屬性
    let pageBounds = page.bounds(for: .mediaBox)
    let rotation = page.rotation // 頁面的旋轉角度（0, 90, 180, 270）
    
    // 5. 調整簽名位置，根據頁面旋轉調整簽名的 offset
    let adjustedOffset = adjustSignatureOffset(
        rotation: rotation,
        offset: offset,
        signatureSize: signatureSize,
        pageBounds: pageBounds
    )
    
    let signatureFrame = CGRect(
        x: adjustedOffset.x,
        y: adjustedOffset.y,
        width: signatureSize.width,
        height: signatureSize.height
    )
    
    // 6. 創建圖形上下文
    UIGraphicsBeginImageContextWithOptions(pageBounds.size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
        print("❌ 無法創建圖形上下文")
        UIGraphicsEndImageContext()
        return
    }
    
    // 7. 修改繪製邏輯，直接繪製原始頁面內容
    context.saveGState()
    
    // 清除預設的轉換，使用 CGContext 的預設座標系統
    context.scaleBy(x: 1, y: -1)  // 垂直翻轉
    context.translateBy(x: 0, y: -pageBounds.height)  // 調整垂直位置
    
    page.draw(with: .mediaBox, to: context)
    
    context.restoreGState()
    
    // 8. 繪製簽名圖片到頁面
    signatureImage.draw(in: signatureFrame)
    
    // 9. 獲取更新後的頁面圖像
    guard let updatedPageImage = UIGraphicsGetImageFromCurrentImageContext() else {
        print("❌ 無法獲取更新後的頁面圖像")
        UIGraphicsEndImageContext()
        return
    }
    UIGraphicsEndImageContext()
    
    // 10. 替換頁面內容
    guard let newPDFPage = PDFPage(image: updatedPageImage) else {
        print("❌ 無法創建新 PDF 頁面")
        return
    }
    
    // 11. 明確設置頁面旋轉，避免不必要的翻轉
    newPDFPage.rotation = rotation // 保持原頁面的旋轉屬性
    
    // 12. 替換原頁面
    pdfDocument.removePage(at: pageIndex)
    pdfDocument.insert(newPDFPage, at: pageIndex)
    
    // 13. 保存修改後的 PDF
    if pdfDocument.write(to: outputURL) {
        print("✅ 修改後的 PDF 保存成功: \(outputURL)")
    } else {
        print("❌ 保存 PDF 失敗")
    }
}

class SignatureViewController: UIViewController {
    private let signatureView = ORKSignatureView()
    private let savedSignatureImageView = UIImageView()
    private let instructionLabel = UILabel()
    private let savedInstructionLabel = UILabel()
    private var outputPDFPath: URL? // 儲存新 PDF 的路徑
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInstructionLabel()
        setupSignatureView()
        setupSaveButton()
        setupClearButton()
        setupSaveToPDFButton()
        setupSavedSignatureView()
    }
    
    private func setupInstructionLabel() {
        instructionLabel.text = "請在下方框內簽名"
        instructionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .darkGray
        instructionLabel.frame = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: 30)
        view.addSubview(instructionLabel)
    }
    
    private func setupSignatureView() {
        signatureView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 150)
        signatureView.backgroundColor = .white
        signatureView.layer.cornerRadius = 10
        signatureView.clipsToBounds = true
        signatureView.layer.borderWidth = 2
        signatureView.layer.borderColor = UIColor.systemBlue.cgColor
        view.addSubview(signatureView)
    }
    
    private func setupSaveButton() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("儲存簽名", for: .normal)
        saveButton.frame = CGRect(x: 20, y: 270, width: view.frame.width - 40, height: 50)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveSignature), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    private func setupClearButton() {
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("清除簽名", for: .normal)
        clearButton.frame = CGRect(x: 20, y: 330, width: view.frame.width - 40, height: 50)
        clearButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.backgroundColor = .systemRed
        clearButton.layer.cornerRadius = 10
        clearButton.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
        view.addSubview(clearButton)
    }
    
    private func setupSaveToPDFButton() {
        let saveToPDFButton = UIButton(type: .system)
        saveToPDFButton.setTitle("嵌入簽名到 PDF", for: .normal)
        saveToPDFButton.frame = CGRect(x: 20, y: 390, width: view.frame.width - 40, height: 50)
        saveToPDFButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveToPDFButton.setTitleColor(.white, for: .normal)
        saveToPDFButton.backgroundColor = .systemGreen
        saveToPDFButton.layer.cornerRadius = 10
        saveToPDFButton.addTarget(self, action: #selector(saveSignatureToPDF), for: .touchUpInside)
        view.addSubview(saveToPDFButton)
    }
    
    private func setupSavedSignatureView() {
        savedInstructionLabel.text = "這是儲存的簽名資料"
        savedInstructionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        savedInstructionLabel.textAlignment = .center
        savedInstructionLabel.textColor = .darkGray
        savedInstructionLabel.frame = CGRect(x: 20, y: 450, width: view.frame.width - 40, height: 30)
        view.addSubview(savedInstructionLabel)
        
        savedSignatureImageView.frame = CGRect(x: 20, y: 490, width: view.frame.width - 40, height: 150)
        savedSignatureImageView.layer.cornerRadius = 10
        savedSignatureImageView.clipsToBounds = true
        savedSignatureImageView.layer.borderWidth = 2
        savedSignatureImageView.layer.borderColor = UIColor.systemGreen.cgColor
        savedSignatureImageView.contentMode = .scaleAspectFit
        savedSignatureImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(savedSignatureImageView)
    }
    
    @objc private func clearSignature() {
        signatureView.clear()
        savedSignatureImageView.image = nil
        print("Signature cleared.")
    }
    
    @objc private func saveSignature() {
        if let signatureImage = signatureView.signatureImage() {
            savedSignatureImageView.image = signatureImage
            print("Signature saved successfully.")
        } else {
            print("No signature available.")
        }
    }
    
    @objc private func saveSignatureToPDF() {
        guard let signatureImage = savedSignatureImageView.image else {
            print("❌ 簽名圖片不存在")
            return
        }
        
        // 獲取專案內的 SportSign.pdf
        guard let pdfURL = Bundle.main.url(forResource: "SportSign", withExtension: "pdf") else {
            print("❌ 找不到 SportSign.pdf")
            return
        }
        
        // 定義輸出的路徑
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("SignedSportSign.pdf")
        self.outputPDFPath = outputURL
        
        // 嵌入簽名到右下角
        embedSignatureWithPDFKit(
            pdfURL: pdfURL,
            signatureImage: signatureImage,
            pageIndex: 0, // 插入到第一頁
            signatureSize: CGSize(width: 200, height: 100), // 簽名尺寸
            offset: CGPoint(x: 380, y: 700), // 調整 y 值，使簽名更接近底部
            outputURL: outputURL
        )
        
        // 預覽生成的 PDF
        previewPDF(at: outputURL)
    }
    
    private func previewPDF(at url: URL) {
        let pdfViewController = UIViewController()
        pdfViewController.view.backgroundColor = .white
        
        let pdfView = PDFView(frame: pdfViewController.view.bounds)
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        
        pdfViewController.view.addSubview(pdfView)
        self.present(pdfViewController, animated: true, completion: nil)
    }
}
