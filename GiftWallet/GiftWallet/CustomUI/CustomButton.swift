//
//  CustomButton.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .customButton
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont(style: .medium, size: 20)
        self.layer.cornerRadius = 5
    }

}
