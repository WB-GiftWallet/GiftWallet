//
//  Gift.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/23.
//

import UIKit

struct Gift {
    let id: UUID
    let image: UIImage?
    let category: Category?
    let brandName: String?
    let productName: String?
    let memo: String?
    let useableState: Bool = false
    let expireDate: Date?
    let useDate: Date? = nil
}

enum Category {
    case chicken
    case cafe
    case bread
}

extension Gift {
    static let sampleGifts: [Gift] = [
        Gift(id: UUID(), image: UIImage(named: "testImageEDIYA"), category: .chicken, brandName: "이디야커피", productName: "아메리카노", memo: "회사선물", expireDate: Date().addFromTodayDate(30)),
        Gift(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL"), category: nil, brandName: nil, productName: nil, memo: "안녕", expireDate: Date().addFromTodayDate(100)),
        Gift(id: UUID(), image: UIImage(named: "testImageEDIYA"), category: .cafe, brandName: "이디양", productName: "이것맛있음", memo: "", expireDate: Date()),
        Gift(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL"), category: .bread, brandName: "모르는곳인데용", productName: "제품의이름이겠지", memo: nil, expireDate: nil),
        Gift(id: UUID(), image: nil, category: .chicken, brandName: "어뭐지", productName: nil, memo: nil, expireDate: nil),
        Gift(id: UUID(), image: nil, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: nil),
        Gift(id: UUID(), image: UIImage(named: "testImageEDIYA"), category: .chicken, brandName: "와ㅣㅂ저다ㅣ", productName: "읭?", memo: "메모는이거지", expireDate: nil)
    ]
}

fileprivate extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        return valueDaysLater
    }
}


