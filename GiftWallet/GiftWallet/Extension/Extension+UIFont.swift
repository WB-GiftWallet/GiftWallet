//
//  Extension+UIFont.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/06.
//

import UIKit.UIFont

extension UIFont {
    convenience init?(style: FontStyle, size: CGFloat) {
        self.init(name: style.description, size: size)
    }
}

enum FontStyle {
    case black, bold, light, medium, regular, thin
    case bmJua
    
    var description: String {
        switch self {
        case .black:
            return "NotoSansKR-Black"
        case .bold:
            return "NotoSansKR-Bold"
        case .light:
            return "NotoSansKR-Light"
        case .medium:
            return "NotoSansKR-Medium"
        case .regular:
            return "NotoSansKR-Regular"
        case .thin:
            return "NotoSansKR-Thin"
        case .bmJua:
            return "BMJUAOTF"
        }
    }
}
