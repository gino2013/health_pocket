//
//  UIView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/26.
//

import Foundation
import UIKit

/// `UIView` 的擴展，提供了添加陰影和圓角等視覺效果的便利方法。
extension UIView {
    
    /// 為視圖添加陰影效果。
    ///
    /// - Parameters:
    ///   - color: 陰影的顏色。
    ///   - opacity: 陰影的透明度，範圍從 0.0 到 1.0。
    ///   - radius: 陰影的模糊半徑。
    ///   - offset: 陰影的偏移量。
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    /// 只為視圖的上方添加陰影效果。
    ///
    /// - Parameters:
    ///   - color: 陰影的顏色。
    ///   - opacity: 陰影的透明度，範圍從 0.0 到 1.0。
    ///   - radius: 陰影的模糊半徑。
    ///   - offset: 陰影的偏移量。
    func addTopShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        
        // 設置陰影路徑，只在視圖的上方添加陰影
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: offset.height + radius))
        shadowPath.addLine(to: CGPoint(x: 0, y: offset.height + radius))
        shadowPath.close()
        
        layer.shadowPath = shadowPath.cgPath
    }
    
    /// 只為視圖的下方添加陰影效果。
    ///
    /// - Parameters:
    ///   - color: 陰影的顏色。
    ///   - opacity: 陰影的透明度，範圍從 0.0 到 1.0。
    ///   - radius: 陰影的模糊半徑。
    ///   - offset: 陰影的偏移量。
    func addBottomShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset

        // 設置陰影路徑，只在視圖的下方添加陰影
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height + offset.height + radius))
        shadowPath.addLine(to: CGPoint(x: 0, y: bounds.height + offset.height + radius))
        shadowPath.close()
        
        layer.shadowPath = shadowPath.cgPath
    }

    /// 為指定的角添加圓角效果。
    ///
    /// - Parameters:
    ///   - corners: 指定要添加圓角的角，可以使用 `.layerMinXMinYCorner` 等常數。
    ///   - radius: 圓角的半徑。
    func roundCACorners(_ corners: CACornerMask, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    /// 為視圖的所有角添加圓角效果。
    ///
    /// - Parameter radius: 圓角的半徑，默認為 25。
    func corner(radius: CGFloat = 25) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 為視圖的四個方向（上、下、左、右）分別添加陰影效果。
    ///
    /// - Parameters:
    ///   - topColor: 上方陰影的顏色，默認為透明。
    ///   - topOpacity: 上方陰影的透明度，默認為 0。
    ///   - topRadius: 上方陰影的模糊半徑，默認為 0。
    ///   - topOffset: 上方陰影的偏移量，默認為 `CGSize.zero`。
    ///   - bottomColor: 下方陰影的顏色，默認為透明。
    ///   - bottomOpacity: 下方陰影的透明度，默認為 0。
    ///   - bottomRadius: 下方陰影的模糊半徑，默認為 0。
    ///   - bottomOffset: 下方陰影的偏移量，默認為 `CGSize.zero`。
    ///   - leftColor: 左方陰影的顏色，默認為透明。
    ///   - leftOpacity: 左方陰影的透明度，默認為 0。
    ///   - leftRadius: 左方陰影的模糊半徑，默認為 0。
    ///   - leftOffset: 左方陰影的偏移量，默認為 `CGSize.zero`。
    ///   - rightColor: 右方陰影的顏色，默認為透明。
    ///   - rightOpacity: 右方陰影的透明度，默認為 0。
    ///   - rightRadius: 右方陰影的模糊半徑，默認為 0。
    ///   - rightOffset: 右方陰影的偏移量，默認為 `CGSize.zero`。
    func addShadow(topColor: UIColor = .clear, topOpacity: Float = 0, topRadius: CGFloat = 0, topOffset: CGSize = .zero,
                   bottomColor: UIColor = .clear, bottomOpacity: Float = 0, bottomRadius: CGFloat = 0, bottomOffset: CGSize = .zero,
                   leftColor: UIColor = .clear, leftOpacity: Float = 0, leftRadius: CGFloat = 0, leftOffset: CGSize = .zero,
                   rightColor: UIColor = .clear, rightOpacity: Float = 0, rightRadius: CGFloat = 0, rightOffset: CGSize = .zero) {
        layer.masksToBounds = false
        
        if topOpacity > 0 {
            let topShadowLayer = createShadowLayer(color: topColor, opacity: topOpacity, radius: topRadius, offset: topOffset)
            layer.addSublayer(topShadowLayer)
        }
        
        if bottomOpacity > 0 {
            let bottomShadowLayer = createShadowLayer(color: bottomColor, opacity: bottomOpacity, radius: bottomRadius, offset: bottomOffset)
            layer.addSublayer(bottomShadowLayer)
        }
        
        if leftOpacity > 0 {
            let leftShadowLayer = createShadowLayer(color: leftColor, opacity: leftOpacity, radius: leftRadius, offset: leftOffset)
            layer.addSublayer(leftShadowLayer)
        }
        
        if rightOpacity > 0 {
            let rightShadowLayer = createShadowLayer(color: rightColor, opacity: rightOpacity, radius: rightRadius, offset: rightOffset)
            layer.addSublayer(rightShadowLayer)
        }
    }
    
    /// 創建一個陰影圖層。
    ///
    /// - Parameters:
    ///   - color: 陰影的顏色。
    ///   - opacity: 陰影的透明度，範圍從 0.0 到 1.0。
    ///   - radius: 陰影的模糊半徑。
    ///   - offset: 陰影的偏移量。
    /// - Returns: 配置好的 `CALayer` 陰影圖層。
    private func createShadowLayer(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOffset = offset
        shadowLayer.frame = bounds
        shadowLayer.masksToBounds = false
        return shadowLayer
    }
}
