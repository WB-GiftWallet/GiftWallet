//
//  DetailViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/07.
//

import Foundation

class DetailViewModel {
    
    private let coredataManager = CoreDataManager.shared
    
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
    
    func coreDataUpdate() {
        do {
            try coredataManager.updateData(gift)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
