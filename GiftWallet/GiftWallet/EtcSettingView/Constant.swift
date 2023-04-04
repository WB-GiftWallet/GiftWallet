//
//  Constant.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import Foundation

enum Constant: Int {
    case history
    case authorizeSetting
    case accountSetting
    
    var sectionDescription: String {
        switch self {
        case .history:
            return "사용내역"
        case .authorizeSetting:
            return "권한 설정"
        case .accountSetting:
            return "계정 설정"
        }
    }
    
    enum History: Int {
        case useHistory
        
        var labelDescription: String {
            switch self {
            case .useHistory:
                return "사용내역"
            }
        }
    }
    
    enum AuthorizeSetting: Int {
        case pushState
        case settingPush
        case settingPushTime
        
        var labelDescription: String {
            switch self {
            case .pushState:
                return "푸시알림"
            case .settingPush:
                return "푸시알림 설정"
            case .settingPushTime:
                return "알림 시각"
            }
        }
    }
    
    enum AccountSetting: Int {
        case deleteAccount
        
        var labelDescription: String {
            switch self {
            case .deleteAccount:
                return "탈퇴하기"
            }
        }
    }
    
}
