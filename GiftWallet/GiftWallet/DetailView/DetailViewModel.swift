//
//  DetailViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/07.
//

import Foundation

class DetailViewModel {
    
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
    
    var brandName: String? {
        return gift.brandName
    }
    
    var productName: String? {
        return gift.productName
    }
    
    var expirdDate: String? {
        return gift.expireDate?.setupDateStyleForDisplay()
    }
    
    var memo: String? {
        return gift.memo
    }
    
    func toggleToUnUsableState() {
        gift.useableState.toggle()
    }
    
}
