//
//  Alarm+CoreDataProperties.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/29.
//
//

import Foundation
import CoreData

extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var numbers: [Int]?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notiType: Int16
    @NSManaged public var title: String?
}

extension Alarm : Identifiable {

}
