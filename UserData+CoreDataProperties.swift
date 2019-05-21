//
//  UserData+CoreDataProperties.swift
//  UnitTestDemo
//
//  Created by KuanWei on 2018/11/29.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var cname: String?
    @NSManaged public var iid: String?
    @NSManaged public var image: NSData?
    @NSManaged public var own: NSSet?

}

// MARK: Generated accessors for own
extension UserData {

    @objc(addOwnObject:)
    @NSManaged public func addToOwn(_ value: Car)

    @objc(removeOwnObject:)
    @NSManaged public func removeFromOwn(_ value: Car)

    @objc(addOwn:)
    @NSManaged public func addToOwn(_ values: NSSet)

    @objc(removeOwn:)
    @NSManaged public func removeFromOwn(_ values: NSSet)

}
