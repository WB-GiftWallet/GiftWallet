//
//  ZoomingImageViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import Foundation

class ZoomingImageViewModel {
    let gift: Gift
    let mode: Mode
    
    init(gift: Gift, mode: Mode) {
        self.gift = gift
        self.mode = mode
    }
}


enum Mode {
    case barcode
    case image
}
