//
//  SellingItemMO+CoreDataProperties.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import Foundation
import CoreData


extension SellingItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SellingItemMO> {
        return NSFetchRequest<SellingItemMO>(entityName: "SellingItem");
    }

    @NSManaged public var itemCondition: String?
    @NSManaged public var barcode: String?
    @NSManaged public var itemDesc: String?
    @NSManaged public var itemID: Int16
    @NSManaged public var itemImage: NSData?
    @NSManaged public var itemName: String?
    @NSManaged public var orderNum: String?
    @NSManaged public var itemQuantity: Int16
    @NSManaged public var sellingPrice: Float
    @NSManaged public var suggestPrice: Float
    @NSManaged public var isSold: Int16
    @NSManaged public var year: Int16
    @NSManaged public var season: String?
    @NSManaged public var added: SellingSectionMO?
    @NSManaged public var sellingNumber: Int16
}
