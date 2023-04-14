//
//  UserNotificationManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/13.
//

import UserNotifications

class UserNotificationManager {
    private let notificationID: String
    private let content = UNMutableNotificationContent()
    private var dateComponents = DateComponents()
    
    init(notificationID: String) {
        self.notificationID = notificationID
    }
    
    func settingContents() {
        content.title = "기한 임박!!"
        content.body = "오늘 사라지는 기프티콘이 있어요!"
        
        content.sound = .default
    }
    
    func requestNotification() {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
            }
        }
    }
}
