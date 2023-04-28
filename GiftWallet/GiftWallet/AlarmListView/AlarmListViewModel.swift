//
//  AlarmListViewModel.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/22.
//

import Foundation

class AlarmListViewModel {
    var alarms: [AlarmModel] = [
        AlarmModel(title: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요",
                   body: "안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽안뇽",
                   date: Date(),
                   id: UUID(),
                   notiType: .couponExpiration),
        
        AlarmModel(title: "네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네네",
                   body: "넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵넵",
                   date: Date(), id: UUID(), notiType: .userNotification),
        
        AlarmModel(title: "밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요밥먹었나요",
                   body: "뭐드셨나요뭐드셨나요뭐드셨나요뭐드셨나요",
                   date: Date(),
                   id: UUID(),
                   notiType: .notification)
    ]
    
}
