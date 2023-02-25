//
//  CoreDataError.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/25.
//

import Foundation

enum CoreDataError: Error {
    case contextInvalid
    case coreDataError
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .contextInvalid:
            return NSLocalizedString("CoreData Context Error", comment: "context Invalid")
        case .coreDataError:
            return "Some CoreData Error"
        }
    }
}
