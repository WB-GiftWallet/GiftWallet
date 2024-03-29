//
//  CoreDataManger.swift
//  ProjectManager
//
//  Created by Baem on 2023/02/24.

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetchData(of numbers: [Int]) -> Result<[Gift], CoreDataError> {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure(.contextInvalid)
        }
        
        do {
            let result = try context.fetch(GiftData.fetchRequest())
            let resultToGiftData = result.filter { numbers.contains(Int($0.number)) }
            let resultToGifts = resultToGiftData.compactMap{ Gift(giftData: $0) }
            return .success(resultToGifts)
        } catch {
            print(error.localizedDescription)
        }
        
        return .failure(.coreDataError)
    }
    
    func fetchData() -> Result<[Gift], CoreDataError> {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure(.contextInvalid)
        }
        
        do {
            let result = try context.fetch(GiftData.fetchRequest())
            let resultToGifts = result.compactMap { Gift(giftData: $0) }
            return .success(resultToGifts)
        } catch {
            print(error.localizedDescription)
        }
        return .failure(.coreDataError)
    }
    
    func saveData(_ giftData: Gift, completion: @escaping (Int16) -> Void) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        let entity = NSEntityDescription.entity(forEntityName: "GiftData", in: context)
        
        let giftDataMostRecentNumber = fetchMostRecentNumber(context: context) + 1
        print("giftDataMostRecentNumber:::" , giftDataMostRecentNumber)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(giftDataMostRecentNumber, forKey: "number")
            info.setValue(giftData.image.pngData(), forKey: "image")
            info.setValue(giftData.category?.rawValue, forKey: "category")
            info.setValue(giftData.brandName, forKey: "brandName")
            info.setValue(giftData.productName, forKey: "productName")
            info.setValue(giftData.memo, forKey: "memo")
            info.setValue(giftData.useableState, forKey: "useableState")
            info.setValue(giftData.expireDate, forKey: "expireDate")
            info.setValue(giftData.useDate, forKey: "useDate")
            do {
                try context.save()
                completion(giftDataMostRecentNumber)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(_ giftData: Gift) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GiftData")
        fetchRequest.predicate = NSPredicate(format: "number = %@", String(giftData.number) as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let updatingData = test[0] as? NSManagedObject else { return }
            
            updatingData.setValue(giftData.number, forKey: "number")
            updatingData.setValue(giftData.image.pngData(), forKey: "image")
            updatingData.setValue(giftData.category?.rawValue, forKey: "category")
            updatingData.setValue(giftData.brandName, forKey: "brandName")
            updatingData.setValue(giftData.productName, forKey: "productName")
            updatingData.setValue(giftData.memo, forKey: "memo")
            updatingData.setValue(giftData.useableState, forKey: "useableState")
            updatingData.setValue(giftData.expireDate, forKey: "expireDate")
            updatingData.setValue(giftData.useDate, forKey: "useDate")
            
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
    
    func updateAllData(_ gifts: [Gift], completion: @escaping () -> Void) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GiftData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        try context.execute(deleteRequest)
        try context.save()
        
        let entity = NSEntityDescription.entity(forEntityName: "GiftData", in: context)
        for gift in gifts {
            if let entity = entity {
                let info = NSManagedObject(entity: entity, insertInto: context)
                info.setValue(gift.number, forKey: "number")
                info.setValue(gift.image.pngData(), forKey: "image")
                info.setValue(gift.category?.rawValue, forKey: "category")
                info.setValue(gift.brandName, forKey: "brandName")
                info.setValue(gift.productName, forKey: "productName")
                info.setValue(gift.memo, forKey: "memo")
                info.setValue(gift.useableState, forKey: "useableState")
                info.setValue(gift.expireDate, forKey: "expireDate")
                info.setValue(gift.useDate, forKey: "useDate")
            }
        }
        
        do {
            try context.save()
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDate(id number: Int16) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GiftData")
        fetchRequest.predicate = NSPredicate(format: "number = %@", String(number) as CVarArg)
        
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
    
    func deleteAllData() throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.contextInvalid
        }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GiftData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        try context.execute(deleteRequest)
        try context.save()
    }
}


extension CoreDataManager {
    private func fetchMostRecentNumber(context: NSManagedObjectContext) -> Int16 {
        let request: NSFetchRequest<GiftData> = GiftData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GiftData.number,
                                                    ascending: false)]
        request.fetchLimit = 1
        if let lastGift = try? context.fetch(request).first {
            let gift = GiftData(context: context)
            gift.number = lastGift.number
            return gift.number
        } else {
            return 0
        }
    }
}
