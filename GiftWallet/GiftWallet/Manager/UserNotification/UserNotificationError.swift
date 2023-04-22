//
//  UserNotificationError.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/22.
//

import Foundation

enum NotificationError: Error {
    case outOfNumbersMostRecent
    case doNotFetchCoreData
    case noExpireContents
    case dateComponentsIsNil
}

extension NotificationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .outOfNumbersMostRecent:
                return NSLocalizedString("Description of outOfNumbersMostRecent", comment: "Invalid Email")
            case .doNotFetchCoreData:
                return NSLocalizedString("Description of do not FetchCoreData", comment: "Fail FetchCoreData")
            case .noExpireContents:
                return NSLocalizedString("Description of do not have ExpireContents", comment: "Invalid Contents")
            case .dateComponentsIsNil:
                return NSLocalizedString("Description of dateComponents have no contents", comment: "Invalid dateComponents")
        }
    }
}
