//
//  EtcSttingViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import Foundation

class EtcSettingViewModel {
    
    private let firebaseManager = FireBaseManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let alarmCoreDataManager = AlarmCoreDataManager.shared
    
    var userName: String? {
        return firebaseManager.currentUserInfo?.displayName
    }
    
    var userEmail: String? {
        return firebaseManager.currentUserInfo?.email
    }
    
    var currentUser: String? {
        return firebaseManager.currentUserID
    }
    
    func signOut() {
        firebaseManager.signOut()
        deleteAllCoreData()
    }
    
    func deleteUser(completion: @escaping () -> Void) {
        firebaseManager.deleteUserAllImageData()
        firebaseManager.deleteUser(completion: completion)
        deleteAllCoreData()
    }
    
    private func deleteAllCoreData() {
        do {
            try coreDataManager.deleteAllData()
            try alarmCoreDataManager.deleteAllData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var sectionNumber: Int {
        return 2
    }
    
    func setupNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func setupSectionHeader(section: Int) -> String {
        guard let constantForSection = Constant(rawValue: section) else { return "" }
        return constantForSection.sectionDescription
    }
}
