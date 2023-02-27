//
//  EtcSttingViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import Foundation

class EtcSettingViewModel {
    
    func setupNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func setupSectionHeader(section: Int) -> String {
        switch section {
        case 0:
            return "계정정보"
        case 1:
            return "권한 설정"
        default:
            return "섹션설정오류"
        }
        
        
    }
    
}
