//
//  OrderMO+CoreDataProperties.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import Foundation
import CoreData


extension OrderMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderMO> {
        return NSFetchRequest<OrderMO>(entityName: "Order");
    }

    @NSManaged public var orderNum: String?
    @NSManaged public var orderDate: String?
    @NSManaged public var orderTime: String?
    @NSManaged public var orderCusName: String?
    @NSManaged public var orderCusPhoneNum: String?
    @NSManaged public var orderCusEMail: String?

}
