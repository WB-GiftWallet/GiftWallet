//
//  MainViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import Foundation
import UIKit

class MainViewModel {
    private let useCase = DateCalculateUseCase()
    
    var allGifts: [Gift] = []
    var expireGifts: Observable<[Gift]> = .init([])
    var recentGifts: Observable<[Gift]> = .init([])
    var unavailableGifts: [Gift] = []
    
    func fetchCoreData() {
        switch CoreDataManager.shared.fetchData() {
        case .success(let data):
            allGifts = data
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func sortOutInGlobalThread() {
        DispatchQueue.global().async { [self] in
            sortOutAsTodaysDate()
        }
    }
    
    private func sortOutAsTodaysDate() {
        useCase.sortOutRecentDate(recentGifts, allGifts)
        useCase.sortOutExpireDate(expireGifts, allGifts)
    }
}

/* unavailable Logic (수정필요)
 //        unavailableGifts = allGifts.filter({ gift in
 //            guard let giftExpireDateNotNil = gift.expireDate else { return false }
 //            return gift.useableState == false || calendar.checkIsExpired(expireDate: giftExpireDateNotNil)
 //        })
 */
