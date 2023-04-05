//
//  FireBaseManagerError.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/30.
//

enum FireBaseManagerError: Error {
    case createUserFail
    case invaildUserID
    case notHaveID
    
    case invalidImage
    case giftDataNotChangeString
    case dateError
    
    //MARK: CRUD
    case fetchDataError
}
