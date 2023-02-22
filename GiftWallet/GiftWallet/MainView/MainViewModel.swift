//
//  MainViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import Foundation

class MainViewModel {
    let expireModel: [Gifts] = [
        Gifts(id: UUID(), image: UIImage(named: "testImageEDIYA")!, brandName: "이디야커피", product: "아메리카노 EX", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date())
    ]
    
    let recentModel: [Gifts] = [
        Gifts(id: UUID(), image: UIImage(named: "testImageEDIYA")!, brandName: "이디야커피", product: "아메리카노 EX", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date()),
        Gifts(id: UUID(), image: UIImage(named: "testImageSTARBUCKSSMALL")!, brandName: "스타벅스", product: "아메리카노 T", date: Date())
    ]
    
}


import UIKit

struct Gifts {
    let id: UUID
    let image: UIImage
    let brandName: String
    let product: String
    let date: Date
}
