//
//  NotificationContents.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/15.
//

enum NotificationContents {
    case one
    case three
    case seven
    
    //TODO: Notification Title, body 변경
    var title: String {
        switch self {
            case .one:
                return "기한 임박!!"
            case .three:
                return "기한 임박!!"
            case .seven:
                return "기한 임박!!"
        }
    }
    
    var body: String {
        switch self {
            case .one:
                return "오늘 사라지는 기프티콘이 있어요!"
            case .three:
                return "곧 만료되는 기프티콘이 있어요!"
            case .seven:
                return "일주일 내에 만료되는 기프티콘이 있어요!"
        }
    }
}
