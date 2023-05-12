//
//  AddViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit

class AddViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    private let firebaseManager = FireBaseManager.shared
    private let visionManager = VisionManager()
    private let autoInputUseCase = AutoInputUseCase()
    private let dateCalculateUseCase = DateCalculateUseCase()
    
    let selectedImage: UIImage
    var gift: Gift?
    var userInput: UserInput = UserInput(image: UIImage(systemName: "cloud")!,
                                         brandName: "",
                                         productName: "",
                                         expireDate: Date())
    
    var currentUser: String? {
        return firebaseManager.currentUserID
    }
    
    
    init(seletedImage: UIImage) {
        self.selectedImage = seletedImage
    }
    
    func getTextsFromSeletedImage(page: Page) -> String? {
        let texts = visionManager.textsRecognizeRequest(image: selectedImage)
        
        switch page {
        case .brand:
            return autoInputUseCase.processImageTextsToBrandNameText(imageTexts: texts)
        case .productName:
            return nil
        case .expireDate:
            guard let texts = texts,
                  let processedTexts = autoInputUseCase.processImageTextsToBrandNameText(imageTexts: texts),
                  let convertToDate = DateFormatter.convertToDisplyStringToExpireDate(dateText: processedTexts),
                  let checkValidDate = dateCalculateUseCase.checkValidDate(expireDate: convertToDate) else { return nil }
            return DateFormatter.convertToDisplayStringInputStyle(date: checkValidDate)
        }
    }
    
    func createLocalDBAndRemoteDB(completion: @escaping () -> Void) {
        createCoreData { [weak self] giftNumber in
            let int16ToIntNumber = Int(giftNumber)
            self?.createFireStoreDocument(int16ToIntNumber) {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private func createFireStoreDocument(_ number: Int, completion: @escaping () -> Void) {
        guard let gift = gift else { return }
        
        do {
            try firebaseManager.saveData(giftData: gift, number: number)
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createCoreData(completion: @escaping (Int16) -> Void) {
        guard let gift = gift else { return }
        
        do {
            try coreDataManager.saveData(gift, completion: completion)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func buttonActionByPage(page: Page, _ value: String) {
        switch page {
        case .brand:
            userInput.makeBrand(value)
        case .productName:
            userInput.makeProductName(value)
        case .expireDate:
            userInput.makeExpireDate(value)
            makeGiftInstance(userInput)
        }
    }
    
    private func makeGiftInstance(_ data: UserInput) {
        let inputtedGift = Gift(image: selectedImage,
                                category: nil,
                                brandName: userInput.brandName,
                                productName: userInput.productName,
                                memo: nil,
                                expireDate: userInput.expireDate)
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
    
    mutating func makeExpireDate(_ value: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        if let dateValue = dateFormatter.date(from: value) {
            expireDate = dateValue
        }
    }
}

