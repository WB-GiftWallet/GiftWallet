//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
    let userNotificationUseCase = UserNotificationUseCase()
    
    func requestNotification() throws {
        // MARK: notification 삭제
        for identifier in 0...29 {
            let id = "Notification\(identifier)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
        
        // MARK: [Fetch] 30+6일 정렬 -> [[number]]
        var recent36Days = [[Int]]()
        
        do {
            recent36Days = try userNotificationUseCase.mostRecentExpireItemFetchCoreData(from: 0, to: 36)
        } catch {
            print(error.localizedDescription)
        }
        
        // MARK: 현재부터 0~6일 남은 것 중 가장 조금 남은 것 NotificationExpireDayContents로 반환
        var notificationContents: NotificationExpireDayContents?
        
        // MARK: 0~29일까지 조건이 맞다면 noti
        for startDay in 0...29 {
            
            // MARK: Notification id 생성 및 startDay 따른 (Noti 정보 & Contents 구성) Setting
            let notifiactionIdentifier = "Notification\(startDay)"
            var totalValue: Int = .zero // 1,3,7 중 하나에서 Item이 몇 개 남은지 count
            var sendingArray: [Int] = [Int]() // 남은 Item의 Number id 값
            
            totalValue += recent36Days[startDay].count
            
            if recent36Days[startDay].count != 0 {
                notificationContents = .today
                
                totalValue = recent36Days[startDay].count
                sendingArray = recent36Days[startDay]
                
            } else if recent36Days[startDay+2].count != 0 {
                notificationContents = .underThree
                
                for i in startDay...startDay+2 {
                    totalValue += recent36Days[i].count
                    sendingArray += recent36Days[i]
                }
                
            } else if recent36Days[startDay+6].count != 0 {
                notificationContents = .underSeven
                
                for i in startDay...startDay+6 {
                    totalValue += recent36Days[i].count
                    sendingArray += recent36Days[i]
                }
            } else {
                //MARK: noti 없음 == continue
                continue
            }
            
            //MARK: nil 이면 0~6 범위, -> return
            guard let notificationContents = notificationContents else {
                throw NotificationError.noExpireContents
            }
            
            //MARK: Contents (1, 3, 7 알람에 해당하는) Setting
            let contentsOfToday = setContents(totalValue, notificationContents)
            
            guard let dateComponents = setupNotificationDateComponents(after: startDay) else {
                throw NotificationError.dateComponentsIsNil
            }
            
            //MARK: Trigger Setting
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // MARK: Request Setting
            let request = UNNotificationRequest(identifier: notifiactionIdentifier, content: contentsOfToday, trigger: trigger)
            
            // MARK: Add UserNotification
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil { }
            }
            
            saveAlarmCoreDataUsingAlarmModel(dateComponents: dateComponents,
                                             contentsTitle: contentsOfToday.title,
                                             sendingArray: sendingArray)
        }
    }
    
    //MARK: -UserNotification 이후 AlarmCoreData Save 로직
    func saveAlarmCoreDataUsingAlarmModel(dateComponents: DateComponents,
                                          contentsTitle: String,
                                          sendingArray: [Int]) {
        let calendar = Calendar.current
        guard let dateFromDateComponent = calendar.date(from: dateComponents) else {
            print("변환 불가능한 DateComponents")
            return
        }
        let dateID = userNotificationUseCase.makeDateID(date: dateFromDateComponent)
        
        let alarmModel = AlarmModel(title: contentsTitle,
                                    numbers: sendingArray,
                                    date: dateFromDateComponent,
                                    id: dateID,
                                    notiType: .couponExpiration)
        
        do {
            try AlarmCoreDataManager.shared.saveData(alarmModel) {
                print("Success SaveData OF AlarmCoreDataManaer")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupNotificationDateComponents(after notiDay: Int) -> DateComponents? {
        let now = Date()
        var notiDateComponent = DateComponents()
        notiDateComponent.day = notiDay
        
        let calendar = Calendar.current
        guard let dateAfterDays = calendar.date(byAdding: notiDateComponent, to: now) else { return nil }
        var dateComponentsAfterDays = calendar.dateComponents([.year, .month, .day], from: dateAfterDays)
        
        //MARK: 시간대 Setting
        dateComponentsAfterDays.hour = UserDefaults.standard.integer(forKey: "NotificationHour")
        
        return dateComponentsAfterDays
    }
    
    private func setContents(_ expireCount: Int, _ contents: NotificationExpireDayContents) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = contents.title
        content.body = "\(expireCount)개 " + contents.body
        content.sound = .default
        
        return content
    }
    
    //MARK: requestNotification로직 내에서 사용 중 (archive)
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

//MARK: -TEST Logic
extension UserNotificationManager {
    
    // MARK: 1분 단위 테스트 Logic
    // setupNotificationDateComponents -> TEST_setupNotificationDateComponents 변경하여 사용
    // day -> minute 단위로 실행됨
    private func TEST_setupNotificationDateComponents(after notiDay: Int) -> DateComponents? {
        let now = Date()
        
        var notiDateComponent = DateComponents()
        notiDateComponent.minute = notiDay
        
        let calendar = Calendar.current
        guard let dateAfterDays = calendar.date(byAdding: notiDateComponent, to: now) else { return nil }
        let dateComponentsAfterDays = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateAfterDays)
        
        return dateComponentsAfterDays
    }
}
