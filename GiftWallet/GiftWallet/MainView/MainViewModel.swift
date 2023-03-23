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
    private let coreDataManager = CoreDataManager.shared
    
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
    
    func sortOutInGlobalThread(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [self] in
            sortOutAsTodaysDate()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func subtractionOfDays(expireDate: Date?) -> Int {
        guard let expireDate = expireDate else { return 0 }
        return useCase.subtractionOftheDays(expireDate: expireDate, today: Date())
    }
    
    private func sortOutAsTodaysDate() {
        useCase.sortOutRecentDate(recentGifts, allGifts)
        useCase.sortOutExpireDate(expireGifts, allGifts)
    }
}

// MARK: Update Gift 관련
extension MainViewModel {
    func updateGiftUseable(updategiftNumber: Int) {
        if let index = recentGifts.value.firstIndex(where: { $0.number == updategiftNumber }) {
            recentGifts.value[index].useableState = false
            updateCoreData(gift: recentGifts.value[index])
        } else if let index = expireGifts.value.firstIndex(where: { $0.number == updategiftNumber }) {
            expireGifts.value[index].useableState = false
            updateCoreData(gift: expireGifts.value[index])
        }
        
    }
    
    func deleteCoreData(targetGiftNumber: Int) {
        let int16TargetGiftNumber = Int16(targetGiftNumber)
        
        do {
            try coreDataManager.deleteDate(id: int16TargetGiftNumber)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func updateCoreData(gift: Gift) {
        do {
            try coreDataManager.updateData(gift)
        } catch {
            print(error.localizedDescription)
        }
    }
}
