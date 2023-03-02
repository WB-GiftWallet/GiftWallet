//
//  AddViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit

class AddViewModel {
    let selectedImage: UIImage
    
    var gift: Observable<Gift>?
    var userInput: UserInput = UserInput(image: UIImage(systemName: "cloud")!,
                                         brandName: "",
                                         productName: "",
                                         expireDate: Date())
    init(seletedImage: UIImage) {
        self.selectedImage = seletedImage
    }
    
    func buttonActionByPage(page: Page, _ value: String) {
        switch page {
        case .brand:
            userInput.makeBrand(value)
        case .productName:
            userInput.makeProductName(value)
        case .expireDate:
            userInput.makeExpireDate(Date())
            makeGiftInstance(userInput)
        }
    }
    
    private func makeGiftInstance(_ data: UserInput) {
        let inputtedGift = Gift(image: userInput.image, category: nil, brandName: userInput.brandName, productName: userInput.productName, memo: nil, expireDate: userInput.expireDate)
        gift = .init(inputtedGift)
    }
}

enum Page: Int {
    case brand
    case productName
    case expireDate
    
    var labelDescription: String {
        switch self {
        case .brand:
            return "사용처(브랜드)를 확인해주세요!"
        case .productName:
            return "상품명을 입력해주세요!"
        case .expireDate:
            return "기프티콘 만료일자를 확인해주세요!"
        }
    }
    
    var buttonDescription: String {
        switch self {
        case .brand:
            return "다음"
        case .productName:
            return "다음"
        case .expireDate:
            return "등록하기"
        }
    }
}

struct UserInput {
    var image: UIImage
    var brandName: String
    var productName: String
    var expireDate: Date
    
    mutating func makeBrand(_ value: String) {
        brandName = value
    }
    
    mutating func makeProductName(_ value: String) {
        productName = value
    }
    
    mutating func makeExpireDate(_ value: Date) {
        expireDate = value
    }
}

