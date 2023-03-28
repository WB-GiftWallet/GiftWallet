//
//  CustomGiftTagUIView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/07.
//

import UIKit

class CustomGiftTagUIView: UIView {

    override func draw(_ rect: CGRect) {
        UIColor.cellTagView.setFill()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.85, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX * 0.2, y: rect.maxY))
        path.close()
        path.fill()
    }

}
