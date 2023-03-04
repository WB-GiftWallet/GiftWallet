//
//  Extension+Date.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/02.
//

import Foundation

extension Date {
    func setupDateStyleForDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
}
