//
//  Constant.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import Foundation

enum EtcSettingConstant: Int {
    case accountInfo
    case authorizeSetting
    case customerSupport
    
    var sectionDescription: String {
        switch self {
            case .accountInfo:
                return "계정정보"
            case .authorizeSetting:
                return "권한 설정"
            case .customerSupport:
                return "고객지원"
        }
    }
    
    enum AccountInfo: Int {
        case useHistory
        case noneDefine
        
        var labelDescription: String {
            switch self {
                case .useHistory:
                    return "사용내역"
                case .noneDefine:
                    return "회원탈퇴"
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
    
    enum CustomerSupport: Int {
        case inconvenience
        case moveSite
        case privacyPolicy
        
        var labelDescription: String {
            switch self {
                case .inconvenience:
                    return "불편사항 접수"
                case .moveSite:
                    return "사이트 바로가기"
                case .privacyPolicy:
                    return "개인정보처리방침"
            }
        }
        
        var url: String {
            switch self {
                case .inconvenience:
                    return "https://github.com/WB-GiftWallet/GiftWallet/discussions/categories/q-a-불편사항-접수"
                case .moveSite:
                    return "https://github.com/WB-GiftWallet/GiftWallet/discussions"
                case .privacyPolicy:
                    return "https://velog.io/@wooong/개인정보처리방침"
            }
        }
    }
}

