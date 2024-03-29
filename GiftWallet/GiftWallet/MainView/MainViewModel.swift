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
    private let firebaseManager = FireBaseManager.shared
    
    var allGifts: [Gift] = []
    var expireGifts: Observable<[Gift]> = .init([])
    var recentGifts: Observable<[Gift]> = .init([])
    
    func fetchCoreData() {
        switch coreDataManager.fetchData() {
        case .success(let data):
            allGifts = data
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func sortOutInGlobalThread(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.sortOutAsTodaysDate()
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
    func updateGiftUsableState(updategiftNumber: Int) {
        if let index = recentGifts.value.firstIndex(where: { $0.number == updategiftNumber }) {
            var gift = recentGifts.value[index]
            gift.useableState = false
            updateCoreData(gift: gift)
            updateUseableStateFirebaseStoreDocument(gift: gift)
        } else if let index = expireGifts.value.firstIndex(where: { $0.number == updategiftNumber }) {
            var gift = expireGifts.value[index]
            gift.useableState = false
            updateCoreData(gift: gift)
            updateUseableStateFirebaseStoreDocument(gift: gift)
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
    
    func deleteFirebaseStoreDocument(targetGiftNumber: Int) {
        firebaseManager.deleteDate(targetGiftNumber)
    }
    
    func updateUseableStateFirebaseStoreDocument(gift: Gift) {
        firebaseManager.updateUseableState(gift)
    }
    
}

// MARK: [레거시] Login 상태관련 함수
extension MainViewModel {
    func checkIfUserLoggedIn(completionWhenUserIsNotLoggedIn: @escaping () -> Void,
                             completionWhenUserIsLoggedIn: @escaping () -> Void) {
        if firebaseManager.currentUserID == nil {
            DispatchQueue.main.async {
                completionWhenUserIsNotLoggedIn()
            }
        } else {
            DispatchQueue.main.async {
                completionWhenUserIsLoggedIn()
            }
        }
    }
}
