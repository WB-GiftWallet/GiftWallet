//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
    private let notificationID: String
    private let notificationContents: NotificationContents
    
    private let content = UNMutableNotificationContent()
    private var dateComponents = DateComponents()
    
    init(notificationID: String, notificationContents: NotificationContents) {
        self.notificationID = notificationID
        self.notificationContents = notificationContents
    }
    
    func requestNotification() {
        mostRecentExpireItemFetchFromCoreData()
        setContents(contents: notificationContents)
        setDateComponents()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
            }
        }
    }
    
    private func setContents(contents: NotificationContents) {
        content.title = contents.title
        content.body = contents.body
        
        content.sound = .default
    }
    
    private func setDateComponents() {
        dateComponents.hour = UserDefaults.standard.integer(forKey: "NotificationHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "NotificationMinute")
    }
    
    
}

//MARK: CoreData 데이터 mostRecentExpireDate 가져오기
extension UserNotificationManager {
    private func mostRecentExpireItemFetchFromCoreData() {
        let gifts = fetchFiltedData()
        var mostExpireDate: Int = 7
        let dateFormatter = DateFormatter(dateFormatte: DateFormatteConvention.yyyyMMdd)
        
        for gift in gifts {
            guard let expireDate = gift.expireDate else { return }
            print(judgeGapOfDay(date: expireDate))
            switch judgeGapOfDay(date: expireDate) {
                case 0:
                    mostExpireDate = 0
                    break
                case 1...2:
                    mostExpireDate = min(2, mostExpireDate)
                case 3...6:
                    mostExpireDate = min(6, mostExpireDate)
                default:
                    continue
            }
        }
    }
    
    private func fetchFiltedData() -> [Gift] {
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

extension DateFormatter {
    convenience init(dateFormatte: DateFormatteConvention) {
        self.init()
        self.locale = Locale(identifier: "ko_KR")
        self.timeZone = TimeZone(abbreviation: "KST")
        self.dateFormat = dateFormatte.rawValue
    }
}

enum DateFormatteConvention: String {
    case yyyyMMdd
}
