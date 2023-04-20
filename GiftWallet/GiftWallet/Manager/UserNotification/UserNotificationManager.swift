//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
//    private let notificationID: String = "UserNotification"
    private var dateComponents = DateComponents()
    
    private func requestNotification() {
        
        //MARK: [Fetch] 30+6일 정렬
        var recent36Days = [Int]()
        
        do {
            recent36Days = try mostRecentExpireItemFetchFor_36_DaysFromCoreData()
        } catch NotificationError.doNotFetchCoreData {
            print(NotificationError.doNotFetchCoreData.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
        
        //MARK: 현재부터 0~6일 남은 것 중 가장 조금 남은 것 NotificationExpireDayContents로 반환
        var notificationContents: NotificationExpireDayContents?
        
        // MARK: 0~29일까지 조건이 맞다면 noti
        for startDay in 0...29 {
            
            // MARK: Notification id 생성 및 startDay 따른 (Noti 정보 & Contents 구성) Setting
            let notifiactionIdentifier = "Notification\(startDay)"
            var totalValue: Int = .zero
            
            totalValue += recent36Days[startDay]
            
            if recent36Days[startDay] != 0 {
                notificationContents = .today
                
                totalValue = recent36Days[startDay]
                
            } else if recent36Days[startDay+2] != 0 {
                notificationContents = .underThree
                
                for i in startDay...startDay+2 {
                    totalValue += recent36Days[i]
                }
                
            } else if recent36Days[startDay+6] != 0 {
                notificationContents = .underSeven
                
                for i in startDay...startDay+6 {
                    totalValue += recent36Days[i]
                }
            } else {
                //MARK: noti 없음 == continue
                continue
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
            let request = UNNotificationRequest(identifier: notifiactionIdentifier, content: contentsOfToday, trigger: trigger)
            
            //MARK: Add UserNotification
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                }
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
    private func mostRecentExpireItemFetchFor_36_DaysFromCoreData() throws -> [Int] {
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
