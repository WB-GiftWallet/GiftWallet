//
//  UsageHistoryViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import Foundation

class UsageHistoryViewModel {
    
    private let coredataManager = CoreDataManager.shared
    
    var expiredGifts: [Gift] = []
    var unUesableGifts: [Gift] = []
    
    init() {
        filterData()
    }
    
    private func filterData() {
        switch CoreDataManager.shared.fetchData() {
        case .success(let data):
            let allGifts = data
            unUesableGifts = allGifts.filter { $0.useableState == false }
            expiredGifts = allGifts.filter({ gift in
                guard let expireDate = gift.expireDate else { return false }
                return gift.useableState == true && expireDate < Date()
            })
        case .failure(let error):
            print(error.localizedDescription)
        }
        
    }
}
