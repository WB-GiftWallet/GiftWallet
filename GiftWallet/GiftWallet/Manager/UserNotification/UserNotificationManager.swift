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

struct userDefualtTimeSetting {
    
    static func timeSetting(hour: Int, minute: Int) {
        UserDefaults.standard.set(hour, forKey: "NotificationHour")
        UserDefaults.standard.set(minute, forKey: "NotificationMinute")
    }
}

