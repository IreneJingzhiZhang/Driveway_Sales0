//
//  UserMO+CoreDataProperties.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User");
    }

    @NSManaged public var addr: String?
    @NSManaged public var city: String?
    @NSManaged public var country:String?
    @NSManaged public var email:String?
    @NSManaged public var first:String?
    @NSManaged public var last:String?
    @NSManaged public var password:String?
    @NSManaged public var state:String?
    @NSManaged public var zip:String?
}
