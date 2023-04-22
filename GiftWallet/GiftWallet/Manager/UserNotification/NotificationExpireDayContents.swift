//
//  NotificationExpireDayContents.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/15.
//

enum NotificationExpireDayContents {
    case today
    case underThree
    case underSeven
    
    //TODO: Notification Title, body 변경
    var title: String {
        switch self {
            case .today:
                return "오늘 사라지는 기프티콘이 있어요!"
            case .underThree:
                return "곧 만료되는 기프티콘이 있어요!"
            case .underSeven:
                return "일주일 내에 만료되는 기프티콘이 있어요!"
        }
    }
    
    var body: String {
        switch self {
            case .today:
                return "기한 임박!!"
            case .underThree:
                return "기한 임박!!"
            case .underSeven:
                return "기한 임박!!"
        }
    }
}
