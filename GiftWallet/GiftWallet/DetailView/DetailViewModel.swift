//
//  DetailViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/07.
//

import Foundation

class DetailViewModel {
    
    private let coredataManager = CoreDataManager.shared
    
    var gifts: [Gift]
    var indexPathItem: Int?
    
    init(gifts: [Gift], indexPahtRow: Int) {
        self.gifts = gifts
        self.indexPathItem = indexPahtRow
    }
    
    func toggleToUnUsableState(_ indexPathRow: Int) {
        gifts[indexPathRow].useableState.toggle()
    }

    func writeMemo(_ indexPathRow: Int, _ text: String?) {
        gifts[indexPathRow].memo = text
    }
    
    func updateGifts(_ updatedGift: Gift) {
        guard let index = findIndexForGiftWithNumber(updatedGift.number) else { return }
        gifts[index] = updatedGift
    }
    
    func findIndexForGiftWithNumber(_ updatedGiftNumber: Int) -> Int? {
        let index = gifts.firstIndex (where: { $0.number == updatedGiftNumber })
        return index
    }

    func coreDataUpdate(_ indexPathRow: Int) {
        do {
            try coredataManager.updateData(gifts[indexPathRow])
        } catch {
            print(error.localizedDescription)
        }
    }
}
