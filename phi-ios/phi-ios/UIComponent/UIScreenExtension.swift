//
//  UIScreenExtension.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/11/07.
//

import UIKit

extension UIScreen {

    /**
     Aspect ratio of current screen's width and 4.7 inches screen's width.
     */
    class func aspectRatioOfWidthBy4_7() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth / 375.0
    }

    class func aspectRatioOfHeightBy4_7() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight / 667.0
    }

    class func aspectRatioBy4_7() -> (width: CGFloat, height: CGFloat) {
        return (aspectRatioOfWidthBy4_7(), aspectRatioOfHeightBy4_7())
    }
}
