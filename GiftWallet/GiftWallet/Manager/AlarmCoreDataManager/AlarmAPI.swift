//
//  AlarmAPI.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/30.
//

import Foundation

enum AlarmType: Int {
    case notification = 0 // 공지
    case couponExpiration // 내부 알람
    case userNotification // UserNotification 알람
    
    var alarmImageSymbolsDescription: String {
        switch self {
        case .notification:
            return "speaker.wave.3"
        case .couponExpiration:
            return "bell"
        case .userNotification:
            return  "network"
        }
    }
}
