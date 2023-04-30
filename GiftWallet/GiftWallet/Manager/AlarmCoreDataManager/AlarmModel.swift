//
//  AlarmModel.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/30.
//

import Foundation

struct AlarmModel {
    var title: String?
    var numbers: [Int]?
    var date: Date?
    var id: String?
    var notiType: AlarmType?
    
    init(title: String,
         numbers: [Int],
         date: Date,
         id: String,
         notiType: AlarmType) {
        self.title = title
        self.numbers = numbers
        self.date = date
        self.id = id
        self.notiType = notiType
    }
    
    init?(alarm: Alarm) {
        self.title = alarm.title
        self.numbers = alarm.numbers
        self.date = alarm.date
        self.id = alarm.id
        self.notiType = AlarmType(rawValue: Int(alarm.notiType))
    }
}

extension AlarmModel {
    static let sampleCoreAlarmModel: [AlarmModel] =
    [AlarmModel(title: "첫번째 타이틀", numbers: [1,2,45], date: Date(), id: "1번째", notiType: AlarmType.couponExpiration),
     AlarmModel(title: "2번째 타이틀", numbers: [1,2,45], date: Date(), id: "2번째", notiType: AlarmType.couponExpiration),
     AlarmModel(title: "3번째 타이틀", numbers: [61,2,45], date: Date(), id: "3번째", notiType: AlarmType.couponExpiration),
     AlarmModel(title: "4번째 타이틀", numbers: [13,2,45], date: Date(), id: "4번째", notiType: AlarmType.couponExpiration),
     AlarmModel(title: "5번째 타이틀", numbers: [11,2,45], date: Date(), id: "5번째", notiType: AlarmType.couponExpiration),
     AlarmModel(title: "6번째 타이틀", numbers: [1,2,45], date: Date(), id: "6번째", notiType: AlarmType.notification),
     AlarmModel(title: "7번째 타이틀", numbers: [16,2,45], date: Date(), id: "7번째", notiType: AlarmType.notification),
     AlarmModel(title: "8번째 타이틀", numbers: [14,2,45], date: Date(), id: "8번째", notiType: AlarmType.userNotification),
     AlarmModel(title: "9번째 타이틀", numbers: [1,23,45], date: Date(), id: "9번째", notiType: AlarmType.userNotification),
     AlarmModel(title: "10번째 타이틀", numbers: [14,2,45], date: Date(), id: "10번째", notiType: AlarmType.userNotification)
    ]
    
    static func addSampleData() {
        AlarmModel.sampleCoreAlarmModel.forEach { alarm in
            try? AlarmCoreDataManager.shared.saveData(alarm, completion: {
                print("success")
            })
        }
    }
    
    static func fetchSampleData() {
        switch AlarmCoreDataManager.shared.fetchData() {
                
            case .success(let data):
                print(data)
            case .failure(_):
                print("실행 실패")
        }
    }
}
