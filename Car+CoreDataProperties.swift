//
//  Car+CoreDataProperties.swift
//  UnitTestDemo
//
//  Created by KuanWei on 2018/11/29.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}
