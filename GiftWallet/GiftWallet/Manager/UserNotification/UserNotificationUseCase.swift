//
//  UserNotificationUseCase.swift
//  GiftWallet
//
//  Created by Baem on 2023/05/06.
//

import Foundation

struct UserNotificationUseCase {
    
    func mostRecentExpireItemFetchCoreData(from startDay: Int, to endDay: Int) throws -> [[Int]] {
        let gifts = fetchFilteredData()
        
        var resultDaysOfIDNumber = Array(repeating: [Int](), count: endDay)
        
        for gift in gifts {
            guard let expireDate = gift.expireDate else {
                throw NotificationError.doNotFetchCoreData
            }
            
            let idNumber = gift.number
            
            let day = judgeGapOfDay(date: expireDate)
            switch day {
                case startDay...endDay:
                    resultDaysOfIDNumber[day].append(idNumber)
                default:
                    continue
            }
        }
        
        return resultDaysOfIDNumber
    }
    
    private func fetchFilteredData() -> [Gift] {
        var gifts = [Gift]()
        
        switch CoreDataManager.shared.fetchData() {
            case .success(let data):
                gifts = data.filter { gift in
                    return gift.useableState
                }
            case .failure(let error):
                print(error.localizedDescription)
        }
        
        return gifts
    }
    
    private func judgeGapOfDay(date: Date) -> Int {
        let formatter = DateFormatter(dateFormatte: DateFormatteConvention.yyyyMMdd)
        let currentDate = Date()
        let expireDate = formatter.string(from: date)
        
        return Int(ceil(formatter.date(from: expireDate)!.timeIntervalSince(currentDate) / 86400))
    }
}

private extension DateFormatter {
    convenience init(dateFormatte: DateFormatteConvention) {
        self.init()
        self.locale = Locale(identifier: "ko_KR")
        self.timeZone = TimeZone(abbreviation: "KST")
        self.dateFormat = dateFormatte.rawValue
    }
}

private enum DateFormatteConvention: String {
    case yyyyMMdd
}
