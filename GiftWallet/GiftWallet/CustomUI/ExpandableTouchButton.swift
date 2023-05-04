//
//  ExpandableTouchButton.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/29.
//

import UIKit

class ExpandedTouchAreaButton: UIButton {
    @IBInspectable var margin: CGFloat = 1000
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}
