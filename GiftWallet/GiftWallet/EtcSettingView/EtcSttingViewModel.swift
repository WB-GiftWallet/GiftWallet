//
//  EtcSttingViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import Foundation

class EtcSettingViewModel {
    
    var sectionNumber: Int {
        return 3
    }
    
    func setupNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
            
        }
    }
    
    func setupSectionHeader(section: Int) -> String {
        guard let constantForSection = Constant(rawValue: section) else { return "" }
        return constantForSection.sectionDescription
    }
}
