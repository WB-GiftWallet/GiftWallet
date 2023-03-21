//
//  DeleteSheetViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/21.
//

import Foundation

class DeleteSheetViewModel {

    var gift: Gift

    init(gift: Gift) {
        self.gift = gift
    }
    
    var giftImageSize: CGSize {
        return gift.image.size
    }
}
