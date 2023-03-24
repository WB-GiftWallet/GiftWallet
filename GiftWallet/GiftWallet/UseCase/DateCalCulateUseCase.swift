//
//  DateCalCulateUseCase.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/28.
//

import Foundation

// MARK: 외부함수
struct DateCalculateUseCase {
    private var expireThresholdDate = 30
    
    func sortOutExpireDate(_ observableGifts: Observable<[Gift]>,
                           _ gifts: [Gift]) {
        observableGifts.value = gifts.filter({ gift in
            guard gift.useableState == true else { return false }
            guard let expireDate = gift.expireDate else { return false }
            return checkExpireDateIsSmallerThanExpireThresholdDate(expireDate: expireDate)
        })
        sortGiftsByDateAscending(observableGifts)
    }
    
    func sortOutRecentDate(_ observableGifts: Observable<[Gift]>,
                           _ gifts: [Gift]) {
        observableGifts.value = gifts.filter({ gift in
            guard gift.useableState == true else { return false }
            guard let expireDate = gift.expireDate else { return true }
            return checkExpireDateIsBiggerThanExpireThresholdDate(expireDate: expireDate)
        })
        sortGiftsByDateAscending(observableGifts)
    }
}

// MARK: 내부함수
extension DateCalculateUseCase {
    func checkExpireDateIsSmallerThanExpireThresholdDate(expireDate: Date) -> Bool {
        let subtractionResult = subtractionOftheDays(expireDate: expireDate, today: Date())
        
        return subtractionResult >= 0 && subtractionResult <= expireThresholdDate ? true : false
    }
    
    func checkExpireDateIsBiggerThanExpireThresholdDate(expireDate: Date) -> Bool {
        let subtractionResult = subtractionOftheDays(expireDate: expireDate, today: Date())
        
        return subtractionResult > expireThresholdDate ? true : false
    }
    
    func subtractionOftheDays(expireDate: Date, today: Date) -> Int {
        let calendar = Calendar.current
        let formattedExpireDate = setupDateFormat(expireDate: expireDate, today: today).0
        let formattedToday = setupDateFormat(expireDate: expireDate, today: today).1
        
        let components = calendar.dateComponents([.day], from: formattedToday, to: formattedExpireDate)
        
        return components.day ?? 0
    }
    
    private func setupDateFormat(expireDate: Date, today: Date) -> (Date, Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let expireDateString = dateFormatter.string(from: expireDate)
        let todayString = dateFormatter.string(from: today)
        
        guard let expireDate = dateFormatter.date(from: expireDateString),
              let today = dateFormatter.date(from: todayString) else {
            return (Date(), Date())
        }
        
        return (expireDate: expireDate, today: today)
    }
    
    private func sortGiftsByDateAscending(_ observableGifts: Observable<[Gift]>) {
        observableGifts.value.sort { gift, compareGift in
            guard let expireDate = gift.expireDate,
                  let compareDate = compareGift.expireDate else { return false }
            return expireDate.compare(compareDate) == .orderedAscending
        }
    }
    
}
