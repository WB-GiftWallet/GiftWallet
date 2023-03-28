//
//  FormSheetViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/15.
//

import Foundation

class UpdateViewModel {
    
    private let coredataManager = CoreDataManager.shared
    
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
    
    func coreDataUpdate() {
        do {
            try coredataManager.updateData(gift)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
