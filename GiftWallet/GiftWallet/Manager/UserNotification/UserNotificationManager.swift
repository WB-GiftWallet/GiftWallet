//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
    private let notificationID: String = "UserNotification" // "20230120"
    private var dateComponents = DateComponents()
    
    private func requestNotification() {
        
        //MARK: [Fetch] 30+6일 정렬
        var recentThirtyDays = [Int]()
        
        do {
            recentThirtyDays = try mostRecentExpireItemFetchForThirtyDaysFromCoreData()
        } catch NotificationError.doNotFetchCoreData {
            print(NotificationError.doNotFetchCoreData.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
        
        //MARK: 현재부터 0~6일 남은 것 중 가장 조금 남은 것 NotificationExpireDayContents로 반환
        var notificationContents: NotificationExpireDayContents?
        
        for day in 0...6 {
            if recentThirtyDays[day] == 0 {
                notificationContents = .today
            } else if recentThirtyDays[day] > 0 && recentThirtyDays[day] <= 2 {
                notificationContents = .underThree
            } else if recentThirtyDays[day] > 2 && recentThirtyDays[day] <= 6 {
                notificationContents = .underSeven
            } else {
                continue
            }
            
            break
        }
        
        //MARK: nil 이면 0~6 범위, -> return
        guard let notificationContents = notificationContents else {
            return
        }
        
        //MARK: Contents (1, 3, 7 알람에 해당하는)
        let contentsOfToday = setContents(contents: notificationContents)
        
        //TODO: DateComponenets 특정 시간 -> 매일 다른 시간 설정 해야함
        setDateComponents()
        
        //MARK: Trigger Setting
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //MARK: Request Setting
        //TODO: Identifier 설정 -> id를 해당 일 "1", "2" 혹은 "NotificationDay1" 명확하게?
        let request = UNNotificationRequest(identifier: notificationID, content: contentsOfToday, trigger: trigger)
        
        //MARK: Add UserNotification
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
            }
        }
    }
    
    private func setContents(contents: NotificationExpireDayContents) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = contents.title
        content.body = contents.body
        content.sound = .default
        
        return content
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
    private func mostRecentExpireItemFetchForThirtyDaysFromCoreData() throws -> [Int] {
        let gifts = fetchFiltedData()
        let dateFormatter = DateFormatter(dateFormatte: DateFormatteConvention.yyyyMMdd)
        var thirtyDays = Array(repeating: 0, count: 36)
        
        for gift in gifts {
            guard let expireDate = gift.expireDate else {
                throw NotificationError.doNotFetchCoreData
            }
            
            let day = judgeGapOfDay(date: expireDate)
            switch day {
                case 0...6:
                    thirtyDays[day] += 1
                default:
                    continue
            }
        }
        
        return thirtyDays
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
    case overData
}
