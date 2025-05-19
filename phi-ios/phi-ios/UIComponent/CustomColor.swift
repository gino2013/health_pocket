//
//  CustomColor.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/11/07.
//

import UIKit

/*
extension UIColor {
    convenience init(hex: Int, alpha: Float = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
*/
extension UIColor {
    public convenience init?(hex: String, alpha: Double = 1.0) {
        var pureString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (pureString.hasPrefix("#")) {
            pureString.remove(at: pureString.startIndex)
        }
        if ((pureString.count) != 6) {
            return nil
        }
        let scanner = Scanner(string: pureString)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            self.init(
                red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0))
            return
        }
        return nil
    }
}

extension UIColor {
    static let azure: UIColor = UIColor(red: 0, green: 174, blue: 239, alpha: 1.0)
    
    static let r222g229b224: UIColor = UIColor(red: 222, green: 229, blue: 224, alpha: 1.0)
    
    static let r222g242b251: UIColor = UIColor(red: 222, green: 2242, blue: 251, alpha: 1.0)
    
    static let customGreen: UIColor = UIColor(red: 28, green: 189, blue: 100, alpha: 1.0)
    
    static let dodgerBlue: UIColor = UIColor(red: 51, green: 153, blue: 255, alpha: 1.0)
    
    static let cerulean: UIColor = UIColor(red: 5, green: 157, blue: 214, alpha: 1.0)
    
    static let blueberry: UIColor = UIColor(red: 51, green: 51, blue: 153, alpha: 1.0)
    
    static let mediumBlue: UIColor = UIColor(red: 51, green: 102, blue: 204, alpha: 1.0)
    
    static let customRed: UIColor = UIColor(red: 194, green: 32, blue: 38, alpha: 1.0)
    
    static let slateGrey: UIColor = UIColor(red: 88, green: 88, blue: 91, alpha: 1.0)
    
    static let customYellow: UIColor = UIColor(red: 255, green: 189, blue: 81, alpha: 1.0)
    
    static let r240g240b240: UIColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1.0)
   
    static let r240g168b0: UIColor = UIColor(red: 240, green: 168, blue: 0, alpha: 1.0)
    
    static let r0g89b139: UIColor = UIColor(red: 0, green: 89, blue: 139, alpha: 1.0)
    
    static let defaultFontColor: UIColor = UIColor(red: 172, green: 172, blue: 172, alpha: 1.0)
    
    static let defaultBackgroundColor: UIColor = UIColor(red: 243, green: 245, blue: 249, alpha: 1.0)
    
    static let defaultLineColor: UIColor = UIColor(red: 224, green: 231, blue: 242, alpha: 1.0)
    
    static let r133g193b250: UIColor = UIColor(red: 133, green: 193, blue: 250, alpha: 1.0)
    
    static let r33g219b0: UIColor = UIColor(red: 33, green: 219, blue: 0, alpha: 1.0)
    
    static let r234g236b242: UIColor = UIColor(red: 234, green: 236, blue: 242, alpha: 1.0)
    
    static let r234g234b234: UIColor = UIColor(red: 234, green: 234, blue: 234, alpha: 1.0)
    
    static let r235g33b33: UIColor = UIColor(red: 235, green: 33, blue: 33, alpha: 1.0)
    
    static let r12g204b60: UIColor = UIColor(red: 12, green: 204, blue: 60, alpha: 1.0)
   
    static let r204g204b204: UIColor = UIColor(red: 204, green: 204, blue: 204, alpha: 1.0)
    
    static let r239g239b244: UIColor = UIColor(red: 239, green: 239, blue: 244, alpha: 1.0)
    
    static let r0g166b255: UIColor = UIColor(red: 0, green: 166, blue: 255, alpha: 1.0)
    
    static let r230g246b255: UIColor = UIColor(red: 230, green: 246, blue: 255, alpha: 1.0)
    
    static let r74g74b74: UIColor = UIColor(red: 74, green: 74, blue: 74, alpha: 1.0)
    
    static let r142g142b142: UIColor = UIColor(red: 142, green: 142, blue: 142, alpha: 1.0)
    
    static let r100g212b255: UIColor = UIColor(red: 100, green: 212, blue: 255, alpha: 1.0)
    
    static let r111g0b79: UIColor = UIColor(red: 111, green: 0, blue: 79, alpha: 1.0)
    
    static let r216g216b216: UIColor = UIColor(red: 216, green: 216, blue: 216, alpha: 1.0)
    
    static let r225g37b37: UIColor = UIColor(red: 225, green: 37, blue: 37, alpha: 1.0)
    
    static let r227g0b0: UIColor = UIColor(red: 227, green: 0, blue: 0, alpha: 1.0)
    
    static let r28g189b100: UIColor = UIColor(red: 28, green: 189, blue: 100, alpha: 1.0)
    
    static let r29g189b101: UIColor = UIColor(red: 29, green: 189, blue: 101, alpha: 1.0)
    
    static let r37g170b225: UIColor = UIColor(red: 37, green: 170, blue: 225, alpha: 1.0)
    
    static let r0g174b239: UIColor = UIColor(red: 0, green: 174, blue: 239, alpha: 1.0)
    
    static let r230g231b232: UIColor = UIColor(red: 230, green: 231, blue: 232, alpha: 1.0)
    
    static let r212g215b222: UIColor = UIColor(red: 212, green: 215, blue: 222, alpha: 1.0)
    
    static let r221g221b221: UIColor = UIColor(red: 221, green: 221, blue: 221, alpha: 1.0)
    
    static let r155g155b155: UIColor = UIColor(red: 155, green: 155, blue: 155, alpha: 1.0)
    
    static let r220g220b220: UIColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
    
    static let r233g87b105: UIColor = UIColor(red: 233, green: 87, blue: 105, alpha: 1.0)
    
    static let r175g152b246: UIColor = UIColor(red: 175, green: 152, blue: 246, alpha: 1.0)
    
    static let r235g235b235: UIColor = UIColor(red: 235, green: 235, blue: 235, alpha: 1.0)
    
    static let r0g120b164: UIColor = UIColor(red: 0, green: 120, blue: 164, alpha: 1.0)
    
    static let r244g244b245: UIColor = UIColor(red: 244, green: 244, blue: 245, alpha: 1.0)

    static let r89g161b248: UIColor = UIColor(red: 89, green: 161, blue: 248, alpha: 1.0)
    
    static let r219g107b118: UIColor = UIColor(red: 219, green: 107, blue: 118, alpha: 1.0)
    
    static let r165g165b165: UIColor = UIColor(red: 165, green: 165, blue: 165, alpha: 1.0)
    
    static let r247g247b247: UIColor = UIColor(red: 247, green: 247, blue: 247, alpha: 1.0)
    
    static let r51g200b93: UIColor = UIColor(red: 51, green: 200, blue: 93, alpha: 1.0)
    
    static let r112g112b112: UIColor = UIColor(red: 112, green: 112, blue: 112, alpha: 1.0)
    
    static let r211g237b247: UIColor = UIColor(red: 211, green: 237, blue: 247, alpha: 1.0)
    
    static let r150g150b150: UIColor = UIColor(red: 150, green: 150, blue: 150, alpha: 1.0)
    
    static let r153g153b153: UIColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
    
    static let r170g170b170: UIColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1.0)
    
    static let r107g107b107: UIColor = UIColor(red: 107, green: 107, blue: 107, alpha: 1.0)
    
    static let unSelectedBackgroundColor: UIColor = UIColor(hex: "#EBF5FB", alpha: 1.0)!
    
    static let unSelectedTextColor: UIColor = UIColor(hex: "#434A4E", alpha: 1.0)!
    
    static let selectedBackgroundColor: UIColor = UIColor(hex: "#3399DB", alpha: 1.0)!
    
    static let selectedTextColor: UIColor = UIColor.white
}
