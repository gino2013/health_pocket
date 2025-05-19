//
//  UIImage.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/26.
//

import Foundation
import UIKit
import AVKit

extension UIImage {

    /// 將圖片轉換為 Base64 字符串。
    /// - Returns: 表示圖片的 Base64 編碼字符串。
    func toBase64() -> String {
        var imageData: NSData
        // 圖片轉換為 PNG 格式的二進制數據
        imageData = self.pngData()! as NSData
        // 將二進制數據編碼為 Base64 字符串
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }

    /// 將 Base64 字符串轉換為圖片。
    /// - Parameter strEncodeData: 要轉換的 Base64 編碼字符串。
    /// - Returns: 轉換後的 `UIImage` 對象。
    class func base64ToImage(toImage strEncodeData: String) -> UIImage {
        // 解碼 Base64 字符串為二進制數據
        let dataDecoded = NSData(base64Encoded: strEncodeData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        // 將二進制數據轉換為 UIImage
        let image = UIImage(data: dataDecoded as Data)
        return image!
    }
}
