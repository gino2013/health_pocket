//
//  UIFontExtension.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/11/07.
//

import UIKit

extension UIFont {
    class func systemFontOfSizeByScreenWidth(_ defaultWidth: CGFloat, fontSize: CGFloat) -> UIFont {
        let screenWidth = UIScreen.main.bounds.size.width
        let ratio = screenWidth / defaultWidth
        return UIFont.systemFont(ofSize: floor(fontSize * ratio))
    }
    
    class func boldSystemFontOfSizeByScreenWidth(_ defaultWidth: CGFloat, fontSize: CGFloat) -> UIFont {
        let screenWidth = UIScreen.main.bounds.size.width
        let ratio = screenWidth / defaultWidth
        return UIFont.boldSystemFont(ofSize: floor(fontSize * ratio))
    }
    
    class func fontWithSizeByScreenWidth(_ defaultWidth: CGFloat, fontSize: CGFloat, source: UIFont) -> UIFont {
        let screenWidth = UIScreen.main.bounds.size.width
        let ratio = screenWidth / defaultWidth
        
        return source.withSize(floor(fontSize * ratio))
    }
}
