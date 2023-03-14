//
//  BarcodeViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import Foundation

class BarcodeViewModel {
    let visionManager = VisionManager()
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
}
