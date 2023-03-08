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
    var indexPathRow: Int?
    
    init(gifts: [Gift], indexPahtRow: Int) {
        self.gifts = gifts
        self.indexPathRow = indexPahtRow
    }
    
//    var brandName: String? {
//        return gift.brandName
//    }
//
//    var productName: String? {
//        return gift.productName
//    }
//
//    var expirdDate: String? {
//        return gift.expireDate?.setupDateStyleForDisplay()
//    }
//
//    var memo: String? {
//        return gift.memo
//    }
//
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
    // 기프트 업데이트 메서드 다시봐야할듯? 뭔가 약간 .. 이상한데?
}
