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
    private var recentSevenDays = Array(repeating: Int.zero, count: 7)
    
    func requestNotification() {
        //MARK: 7일 정렬
        do {
            recentSevenDays = try mostRecentExpireItemFetchForSevenDayFromCoreData()
        } catch NotificationError.doNotFetchCoreData {
            print(NotificationError.doNotFetchCoreData.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
        
        
        do {
            let notificationContents: NotificationExpireDayContents = try setNotificationContents(mostRecentExpireDay)
            setContents(contents: notificationContents)
            setDateComponents()
        } catch {
            print(error.localizedDescription)
        }
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//            if error != nil {
//            }
//        }
    }
    
    private func setContents(contents: NotificationExpireDayContents) {
        content.title = contents.title
        content.body = contents.body
        
        content.sound = .default
    }
    
    // TODO: UserDefaults를 이용한 알람 타임 등록
    private func setDateComponents() {
        dateComponents.hour = UserDefaults.standard.integer(forKey: "NotificationHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "NotificationMinute")
    }
    
    private func setNotificationContents(_ mostRecentExpireDay: Int) throws -> NotificationExpireDayContents {
        
        switch mostRecentExpireDay {
            case 0:
                return .today
            case 1...2:
                return .underThree
            case 3...6:
                return .underSeven
            default:
                throw NotificationError.outOfNumbersMostRecent
        }
    }
}

// MARK: CoreData 데이터 mostRecentExpireDate 가져오기
extension UserNotificationManager {
    private func mostRecentExpireItemFetchForSevenDayFromCoreData() throws -> [Int] {
        let gifts = fetchFiltedData()
        let dateFormatter = DateFormatter(dateFormatte: DateFormatteConvention.yyyyMMdd)
        var sevenDays = Array(repeating: 0, count: 7)
        
        for gift in gifts {
            guard let expireDate = gift.expireDate else {
                throw NotificationError.doNotFetchCoreData
            }
            
            let day = judgeGapOfDay(date: expireDate)
            switch day {
                case 0...6:
                    sevenDays[day] += 1
                default:
                    continue
            }
        }
        
        return sevenDays
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
    case doNotFetchCoreData
}
