//
//  SellingSectionMO+CoreDataProperties.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import Foundation
import CoreData


extension SellingSectionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SellingSectionMO> {
        return NSFetchRequest<SellingSectionMO>(entityName: "SellingSection");
    }

    @NSManaged public var currency: String?
    @NSManaged public var payType: String?
    @NSManaged public var seasom: String?
    @NSManaged public var sectionID: NSNumber?
    @NSManaged public var year: NSNumber?
    @NSManaged public var addItems: NSSet?

}

// MARK: Generated accessors for addItems
extension SellingSectionMO {

    @objc(addAddItemsObject:)
    @NSManaged public func addToAddItems(_ value: SellingItemMO)

    @objc(removeAddItemsObject:)
    @NSManaged public func removeFromAddItems(_ value: SellingItemMO)

    @objc(addAddItems:)
    @NSManaged public func addToAddItems(_ values: NSSet)

    @objc(removeAddItems:)
    @NSManaged public func removeFromAddItems(_ values: NSSet)

}
