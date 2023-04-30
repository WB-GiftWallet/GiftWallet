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
            info.setValue(alarm.numbers, forKey: "numbers")
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
            updatingData.setValue(alarm.numbers, forKey: "numbers")
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
