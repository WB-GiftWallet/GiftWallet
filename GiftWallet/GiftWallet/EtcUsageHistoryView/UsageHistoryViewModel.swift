//
//  UsageHistoryViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import Foundation

class UsageHistoryViewModel {
    var unavailableGifts: [Gift]
    
    init(unavailableGifts: [Gift]) {
        self.unavailableGifts = unavailableGifts
    }
}

private extension Date {
    func setupDateStyleForDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
}
