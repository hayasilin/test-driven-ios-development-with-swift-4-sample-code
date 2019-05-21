//
//  ToDoItem.swift
//  UnitTestDemo
//
//  Created by KuanWei on 2018/11/29.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {

    var plistDict: [String: Any] {
        return [:]
    }

    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?

    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }

    init?(dict: [String: Any]) {
        return nil
    }

    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.location != rhs.location {
            return false
        }

        if lhs.timestamp != rhs.timestamp {
            return false
        }

        if lhs.itemDescription != rhs.itemDescription {
            return false
        }

        if lhs.title != rhs.title {
            return false
        }
        return true
    }
}
