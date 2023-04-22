//
//  Constant.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import Foundation

enum Constant: Int {
    case accountInfo
    case authorizeSetting
    
    var sectionDescription: String {
        switch self {
        case .accountInfo:
            return "계정정보"
        case .authorizeSetting:
            return "권한 설정"
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
}
