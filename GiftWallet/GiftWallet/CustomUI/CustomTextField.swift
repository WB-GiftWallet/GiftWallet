//
//  CustomTextField.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/02.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearButtonMode = .always

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextFieldBottomBorder() {
        guard layer.sublayers?.first(where: { $0.name == "textFieldBottomBorderLayerName" }) == nil else { return }
        self.layoutIfNeeded()
        let borderColor: UIColor = .systemGray
        let border = CALayer()
        border.name = "textFieldBottomBorderLayerName"
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height + 5,
                              width: self.frame.width,
                              height: 2)
        border.backgroundColor = borderColor.cgColor
        self.layer.addSublayer(border)
    }
    
}
