//
//  AlarmCoreDataManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/26.
//

import CoreData
import UIKit

final class AlarmCoreDataManager {
    
    static let shared = AlarmCoreDataManager()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetchData() -> Result<[AlarmModel], CoreDataError> {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure(.contextInvalid)
        }
        
        do {
            let result = try context.fetch(Alarm.fetchRequest())
            let resultToAlarms = result.compactMap { alarm in
                AlarmModel(alarm: alarm)
            }
            return .success(resultToAlarms)
        } catch {
            print(error.localizedDescription)
        }
        return .failure(.coreDataError)
    }
    
    func saveData(_ alarm: AlarmModel, completion: @escaping () -> Void) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: context)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            
            info.setValue(alarm.title, forKey: "title")
            info.setValue(alarm.id, forKey: "id")
            info.setValue(alarm.body, forKey: "body")
            info.setValue(alarm.date, forKey: "date")
            info.setValue(alarm.notiType?.rawValue, forKey: "notiType")
            
            do {
                try context.save()
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(_ alarm: AlarmModel) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        
        guard let id = alarm.id else {
            return
        }
                
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Alarm")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)

        do {
            let test = try context.fetch(fetchRequest)
            guard let updatingData = test[0] as? NSManagedObject else { return }
            
            updatingData.setValue(alarm.title, forKey: "title")
            updatingData.setValue(alarm.id, forKey: "id")
            updatingData.setValue(alarm.body, forKey: "body")
            updatingData.setValue(alarm.date, forKey: "date")
            updatingData.setValue(alarm.notiType?.rawValue, forKey: "notiType")
            
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDate(id: UUID) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Alarm")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let objectDelete = test[0] as? NSManagedObject else { return }
            
            context.delete(objectDelete)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct AlarmModel {
    var title: String?
    var body: String?
    var date: Date?
    var id: UUID?
    var notiType: AlarmType?
    
    init(title: String,
         body: String,
         date: Date,
         id: UUID,
         notiType: AlarmType) {
        self.title = title
        self.body = body
        self.date = date
        self.id = id
        self.notiType = notiType
    }
    
    init?(alarm: Alarm) {
        self.title = alarm.title
        self.body = alarm.body
        self.date = alarm.date
        self.id = alarm.id
        self.notiType = AlarmType(rawValue: Int(alarm.notiType))
    }
}

extension AlarmModel {
    static let sampleCoreAlarmModel: [AlarmModel] =
    [AlarmModel(title: "첫번째 타이틀", body: "첫번째 바디", date: Date(), id: UUID(), notiType: AlarmType.couponExpiration),
     AlarmModel(title: "2번째 타이틀", body: "2번째 바디", date: Date(), id: UUID(), notiType: AlarmType.couponExpiration),
     AlarmModel(title: "3번째 타이틀", body: "3번째 바디", date: Date(), id: UUID(), notiType: AlarmType.couponExpiration),
     AlarmModel(title: "4번째 타이틀", body: "4번째 바디", date: Date(), id: UUID(), notiType: AlarmType.couponExpiration),
     AlarmModel(title: "5번째 타이틀", body: "5번째 바디", date: Date(), id: UUID(), notiType: AlarmType.couponExpiration),
     AlarmModel(title: "6번째 타이틀", body: "6번째 바디", date: Date(), id: UUID(), notiType: AlarmType.notification),
     AlarmModel(title: "7번째 타이틀", body: "7번째 바디", date: Date(), id: UUID(), notiType: AlarmType.notification),
     AlarmModel(title: "8번째 타이틀", body: "8번째 바디", date: Date(), id: UUID(), notiType: AlarmType.userNotification),
     AlarmModel(title: "9번째 타이틀", body: "9번째 바디", date: Date(), id: UUID(), notiType: AlarmType.userNotification),
     AlarmModel(title: "10번째 타이틀", body: "10번째 바디", date: Date(), id: UUID(), notiType: AlarmType.userNotification)
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

enum AlarmType: Int {
    case notification = 0 // 공지
    case couponExpiration // 내부 알람
    case userNotification // UserNotification 알람
}
