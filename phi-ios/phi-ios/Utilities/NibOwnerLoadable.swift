//
//  NibOwnerLoadable.swift
//  SDK
//
//  Created by Kenneth on 2023/10/3.
//

import UIKit

/// `NibOwnerLoadable` 是一個協議，適用於需要從 `.xib` 文件中加載內容的類別。
protocol NibOwnerLoadable: AnyObject {
    /// 提供對應 `.xib` 文件的 `UINib` 對象。
    static var nib: UINib { get }
}

extension NibOwnerLoadable {
    /// 預設實現：返回對應類別的 `UINib` 對象。
    /// `UINib` 使用與類別名稱相同的 `.xib` 文件，並從相應的 `Bundle` 中加載。
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibOwnerLoadable where Self: UIView {
    /// 加載 `.xib` 文件中的內容並將其添加到視圖中。
    /// 此方法會自動加載與視圖對應的 `.xib` 文件，並將其內容添加到視圖中，並設置約束以適應父視圖。
    func loadNibContent() {
        // 從 .xib 文件中實例化視圖並檢查加載結果
        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
              let contentView = views.first else {
            // 如果加載失敗，觸發運行時錯誤
            fatalError("Warning! Fail to load \(self) nib content!")
        }
        // 將 .xib 文件中的內容視圖添加為子視圖
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 設置約束，使內容視圖填滿父視圖
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
