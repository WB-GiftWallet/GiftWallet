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
        return firebaseManager.currentUser?.displayName
    }
    
    var userEmail: String? {
        return firebaseManager.currentUser?.email
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
        return 3
    }
    
    func setupNumberOfRowsInSection(section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 1:
                return 3
            case 2:
                return 3
            default:
                return 0
        }
    }
    
    func setupSectionHeader(section: Int) -> String {
        guard let constantForSection = EtcSettingConstant(rawValue: section) else { return "" }
        return constantForSection.sectionDescription
    }
    
    func getURL(index: Int) -> String {
        guard let url = EtcSettingConstant.CustomerSupport(rawValue: index)?.url else {
            return ""
        }
        
        return url
    }
}
