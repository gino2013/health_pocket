//
//  QRCodeUtils.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/16.
//

import UIKit

// How to use ...
/*
if let qrCodeImage = QRCodeGenerator.generateQRCode(from: "Your QRCode String", size: CGSize(width: 200, height: 200)) {
    // 使用 qrCodeImage 來顯示 QRCode 圖像
} else {
    print("Failed to generate QRCode")
}
*/

class QRCodeUtils {
    static func generateQRCode(from string: String, size: CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let context = CIContext()
                
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    let image = UIImage(cgImage: cgImage)
                    return image
                }
            }
        }
        
        return nil
    }
}
