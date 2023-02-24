//
//  CoreDataManger.swift
//  ProjectManager
//
//  Created by Baem on 2023/02/24.


import CoreData
import UIKit

enum CoreDataError: Error {
    case contextError
    case coreDataError
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetchData() -> Result<[GiftData], CoreDataError> {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure(.contextError)
        }
        
        do {
            let contact = try context.fetch(GiftData.fetchRequest())
            
            return .success(contact)
        } catch {
            print(error.localizedDescription)
        }
        return .failure(.coreDataError)
    }
    
    func saveData(_ giftData: Gift) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "GiftData", in: context)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(giftData.number, forKey: "number")
            
            // image 데이터화
            info.setValue(giftData.image?.pngData(), forKey: "image")
            // 카테고리 데이터화
            info.setValue(giftData.category?.rawValue, forKey: "category")
            
            info.setValue(giftData.brandName, forKey: "brandName")
            info.setValue(giftData.productName, forKey: "productName")
            info.setValue(giftData.memo, forKey: "memo")
            info.setValue(giftData.useableState, forKey: "useableState")
            info.setValue(giftData.expireDate, forKey: "expireDate")
            info.setValue(giftData.useDate, forKey: "useDate")
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(_ giftData: Gift) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GiftData")
        fetchRequest.predicate = NSPredicate(format: "number = %@", giftData.number as CVarArg)

        do {
            let test = try context.fetch(fetchRequest)
            guard let updatingData = test[0] as? NSManagedObject else { return }
            
            updatingData.setValue(giftData.number, forKey: "number")
            
            // image 데이터화
            updatingData.setValue(giftData.image?.pngData(), forKey: "image")
            // 카테고리 데이터화
            updatingData.setValue(giftData.category?.rawValue, forKey: "category")
            
            updatingData.setValue(giftData.brandName, forKey: "brandName")
            updatingData.setValue(giftData.productName, forKey: "productName")
            updatingData.setValue(giftData.memo, forKey: "memo")
            updatingData.setValue(giftData.useableState, forKey: "useableState")
            updatingData.setValue(giftData.expireDate, forKey: "expireDate")
            updatingData.setValue(giftData.useDate, forKey: "useDate")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDate(id number: Int16) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GiftData")
        fetchRequest.predicate = NSPredicate(format: "number = %@", number as CVarArg)
        
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
