//
//  EtcSttingViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import Foundation

class EtcSettingViewModel {
    var unavailableGifts: [Gift]
    
    init(unavailableGifts: [Gift]) {
        self.unavailableGifts = unavailableGifts
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