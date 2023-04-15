//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
    private let notificationID: String = "UserNotification"
    
    private let content = UNMutableNotificationContent()
    private var dateComponents = DateComponents()
    
    
    func requestNotification() {
        let mostRecentExpireDay = mostRecentExpireItemFetchFromCoreData()
        do {
            let notificationContents: NotificationContents = try setNotificationContents(mostRecentExpireDay)
            setContents(contents: notificationContents)
            setDateComponents()
        } catch {
            print(error.localizedDescription)
        }
        
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
    
    // TODO: UserDefaults를 이용한 알람 타임 등록
    private func setDateComponents() {
        dateComponents.hour = UserDefaults.standard.integer(forKey: "NotificationHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "NotificationMinute")
    }
    
    private func setNotificationContents(_ mostRecentExpireDay: Int) throws -> NotificationContents {
        
        switch mostRecentExpireDay {
            case 0:
                return .one
            case 1...2:
                return .three
            case 3...6:
                return .seven
            default:
                throw NotificationError.outOfNumbersMostRecent
        }
    }
}

// MARK: CoreData 데이터 mostRecentExpireDate 가져오기
extension UserNotificationManager {
    private func mostRecentExpireItemFetchFromCoreData() -> Int {
        let gifts = fetchFiltedData()
        let dateFormatter = DateFormatter(dateFormatte: DateFormatteConvention.yyyyMMdd)
        var mostExpireDate: Int = 7
        
        for gift in gifts {
            guard let expireDate = gift.expireDate else { return 7 }
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
        
        return mostExpireDate
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

struct userDefualtTimeSetting {
    
    func timeSetting(hour: Int, minute: Int) {
        UserDefaults.standard.set(hour, forKey: "NotificationHour")
        UserDefaults.standard.set(minute, forKey: "NotificationMinute")
    }
}

enum NotificationError: Error {
    case outOfNumbersMostRecent
    case notHaveMostRecentDay
}
