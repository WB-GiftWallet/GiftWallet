//
//  FireBaseManagerError.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/30.
//

enum FireBaseManagerError: Error {
    case fetchDataError
    case createUserFail
    case invaildUserID
    case notHaveID
    
    case invalidImage
    case giftDataNotChangeString
    case dateError
}
