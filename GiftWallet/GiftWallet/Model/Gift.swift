//
//  Gift.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/23.
//

import UIKit

struct Gift {
    var number: Int = 0
    var image: UIImage
    let category: Category?
    let brandName: String?
    let productName: String?
    var memo: String?
    var useableState: Bool
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

// MARK: - SampleData 생성 추후 삭제
extension Gift {
    static let sampleCoreGifts: [Gift] = [
        // MARK: expireGifts (5개)
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "EDIYA", productName: "커피1리터", memo: "맛난거", expireDate: Date().addFromTodayDate(0)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .chicken, brandName: "집앞커피점", productName: "나는", memo: "이디양", expireDate: Date().addFromTodayDate(3)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "컴포즈커피", productName: "나는요", memo: "의듸량", expireDate: Date().addFromTodayDate(5)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "멀랑커피", productName: "나는요", memo: "의듸량", expireDate: Date().addFromTodayDate(6)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "몰라분식", productName: "그냥커피5리터", memo: "맛있엉", expireDate: Date().addFromTodayDate(7)),
        
        // MARK: recentGifts (10개)
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "그냥", productName: "그냥커피 1리터", memo: nil, expireDate: Date().addFromTodayDate(8)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "한식", productName: "그냥커피 2리터", memo: "메모가있고", expireDate: Date().addFromTodayDate(10)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "양식", productName: "그냥커피 3리터", memo: "메모가없어", expireDate: Date().addFromTodayDate(100)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "중식", productName: "그냥커피 4리터", memo: nil, expireDate: Date().addFromTodayDate(150)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "김밥", productName: "그냥커피 5리터", memo: "여기도메모있고", expireDate: Date().addFromTodayDate(200)),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "탐앤탐스", productName: "베이컨", memo: "이건 Nil값인데", expireDate: nil),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "현대자동차", productName: "맛있는거", memo: "이건 Nil값인데", expireDate: nil),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "칠칠소막창", productName: "선물받은거", memo: "이건 Nil값인데", expireDate: nil),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "돼지막창", productName: "비싼거", memo: "이건 Nil값인데", expireDate: nil),
        Gift(image: UIImage(named: "testImageSTARBUCKSSMALL")!, category: .cafe, brandName: "곱창", productName: "5000인분", memo: "이건 Nil값인데", expireDate: nil),

        
        // MARK: unavailableGifts (5개)
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "다쓴커피", productName: "그냥커피 1110리터", memo: nil, expireDate: Date().addFromTodayDate(-1)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "다써버린커피", productName: "그냥커피 660리터", memo: nil, expireDate: Date().addFromTodayDate(-2)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "다써버린커피집1", productName: "그냥커피 50리터", memo: nil, expireDate: Date().addFromTodayDate(-3)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "다쓴막창집", productName: "그냥커피 40리터", memo: nil, expireDate: Date().addFromTodayDate(-50)),
        Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "다쓴고기집", productName: "그냥커피 30리터", memo: nil, expireDate: Date().addFromTodayDate(-100))
        
    ]
    
    static func addSampleData() {
        Gift.sampleCoreGifts.forEach { gift in
            try? CoreDataManager.shared.saveData(gift)
        }
    }
}

private extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        print("오늘", currentDate)
        print("추가된일자", valueDaysLater)
        
        return valueDaysLater
    }
}
