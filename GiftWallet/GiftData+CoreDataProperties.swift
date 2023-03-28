//
//  GiftData+CoreDataProperties.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/25.
//
//

import Foundation
import CoreData


extension GiftData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GiftData> {
        return NSFetchRequest<GiftData>(entityName: "GiftData")
    }

    @NSManaged public var brandName: String?
    @NSManaged public var category: String?
    @NSManaged public var expireDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var memo: String?
    @NSManaged public var number: Int16
    @NSManaged public var productName: String?
    @NSManaged public var useableState: Bool
    @NSManaged public var useDate: Date?

}

extension GiftData : Identifiable {

}
