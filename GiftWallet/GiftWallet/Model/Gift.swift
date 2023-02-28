//
//  Gift.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/23.
//

import UIKit

struct Gift {
    var number: Int = 0
    let image: UIImage
    let category: Category?
    let brandName: String?
    let productName: String?
    let memo: String?
    let useableState: Bool
    let expireDate: Date?
    let useDate: Date?

    init(image: UIImage,
         category: Category?,
         brandName: String?,
         productName: String?,
         memo: String?,
         useableState: Bool = true,
         expireDate: Date?,
         useDate: Date? = nil) {
        self.image = image
        self.category = category
        self.brandName = brandName
        self.productName = productName
        self.memo = memo
        self.useableState = useableState
        self.expireDate = expireDate
        self.useDate = useDate
    }
    
    init?(giftData: GiftData) {
        guard let imageData = giftData.image,
              let image = UIImage(data: imageData) else { return nil }
        
        self.number = Int(giftData.number)
        self.image = image
        self.category = Category.bread
        self.brandName = giftData.brandName
        self.productName = giftData.productName
        self.memo = giftData.memo
        self.useableState = giftData.useableState
        self.expireDate = giftData.expireDate
        self.useDate = giftData.useDate
    }
}

enum Category: String {
    case chicken
    case cafe
    case bread
}

extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        return valueDaysLater
    }
}

// MARK: - SampleData 생성 추후 삭제
extension Gift {
    static let sampleCoreGifts: [Gift] = [
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "EDIYA", productName: "커피1리터", memo: "맛난거", expireDate: Date().addFromTodayDate(10)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .chicken, brandName: "하세용", productName: "나는", memo: "이디양", expireDate: Date().addFromTodayDate(15)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "하세령", productName: "나는요", memo: "의듸량", expireDate: Date().addFromTodayDate(20)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "이그저스트커피", productName: "그냥커피5리터", memo: "맛있엉", expireDate: Date().addFromTodayDate(25)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "이그저스트커핑", productName: "그냥커피 50리터", memo: nil, expireDate: Date().addFromTodayDate(100)),
    ]
    
    static func addSampleData() {
        Gift.sampleCoreGifts.forEach { gift in
            try? CoreDataManager.shared.saveData(gift)
        }
    }
}
