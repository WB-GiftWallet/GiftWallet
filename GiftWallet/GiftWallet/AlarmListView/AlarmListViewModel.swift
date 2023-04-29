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
    
    var filteredAlarm: Observable<[AlarmModel]> = .init([])
    
    init() {
        filterAllData()
    }
    
    func filterAlarm(type: AlarmType) {
        filteredAlarm.value = alarms.filter { $0.notiType == type }
    }
    
    func filterAllData() {
        filteredAlarm.value = alarms
    }
    
}


/*
 1. alarm은 전체 알람을 갖는다.
 2. 버튼이 변하면서 필터를 한다.
 3. filteredAlarm은 필터된 알람이 된다.
 4. 결국, 띄워주는 것은 filteredAlarm이 된다.
 
 
 */
