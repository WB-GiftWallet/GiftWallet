//
//  Ext+DateFormatter.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import Foundation

extension DateFormatter {
    static func convertToDisplayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    static func convertToDisplyStringToExpireDate(dateText: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.date(from: dateText)
    }
    
    
    static func convertToDisplayStringInputStyle(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
    
    static func convertToDisplayStringHourMinute(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
