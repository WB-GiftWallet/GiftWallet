//
//  MainViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import Foundation

class MainViewModel {
    var allGifts: [Gift] = []
    var expireGifts: Observable<[Gift]> = .init([])
    var recentGifts: Observable<[Gift]> = .init([])
    var unavailableGifts: [Gift] = []
    
    // TODO: 추후에 코어데이터를 fetch해올 함수
    func fetchSampleData() {
        allGifts = Gift.sampleGifts
    }
    
    func sortedByCurrentDate() {
        let calendar = Calendar.current
        
        expireGifts.value = allGifts.filter({ gift in
            guard let giftExpireDateNotNil = gift.expireDate else { return false }
            return calendar.checkExpireDataIsSevenDays(greaterThanSeven: false, expireDate: giftExpireDateNotNil)
        })
        
        recentGifts.value = allGifts.filter({ gift in
            guard let giftExpireDateNotNil = gift.expireDate else { return true }
            return calendar.checkExpireDataIsSevenDays(greaterThanSeven: true, expireDate: giftExpireDateNotNil)
        })
        
        unavailableGifts = allGifts.filter({ gift in
            guard let giftExpireDateNotNil = gift.expireDate else { return false }
            return gift.useableState == false || calendar.checkIsExpired(expireDate: giftExpireDateNotNil)
            
        })
    }
    
}

fileprivate extension Calendar {
    func checkExpireDataIsSevenDays(greaterThanSeven: Bool, expireDate: Date) -> Bool {
        let today = Date()
        let components = self.dateComponents([.day], from: today, to: expireDate)
        guard let differenceDate = components.day else { return false }
        
        return greaterThanSeven ?  differenceDate > 7 : differenceDate <= 7
    }
    
    func checkIsExpired(expireDate: Date) -> Bool {
        let today = Date()
        let comparisonResult = self.compare(today, to: expireDate, toGranularity: .day)
        
        return comparisonResult == .orderedAscending ? true : false
        
    }
}
