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
    
    init(gifts: [Gift], indexPahtRow: Int = 0) {
        self.gifts = gifts
        self.indexPathItem = indexPahtRow
    }
    
    func toggleToUnUsableState(_ indexPathRow: Int) {
        gifts[indexPathRow].useableState.toggle()
    }

    func writeMemo(_ indexPathRow: Int, _ text: String?) {
        gifts[indexPathRow].memo = text
    }


    func coreDataUpdate(_ indexPathRow: Int) {
        do {
            try coredataManager.updateData(gifts[indexPathRow])
        } catch {
            print(error.localizedDescription)
        }
    }
}
