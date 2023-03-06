//
//  CustomColor.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/06.
//

import UIKit.UIColor

extension UIColor {
    fileprivate convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

extension UIColor {
    static let serachButton = UIColor(r: 238, g: 238, b: 238)
    static let searchLabel = UIColor(r: 189, g: 189, b: 189)
    static let tabbarItemColor = UIColor(r: 196, g: 196, b: 196)
}

