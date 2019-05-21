//
//  ItemCellTests.swift
//  UnitTestDemoTests
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import XCTest
@testable import UnitTestDemo

class ItemCellTests: XCTestCase {

    var controller: ItemListViewController!
    var tableView: UITableView!
    var cell: ItemCell!
    let dataSource = FakeDataSource()

    override func setUp() {
        controller = ItemListViewController()
        controller.loadViewIfNeeded()

        tableView = controller.tableView
        tableView.dataSource = dataSource

        cell = tableView?.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: IndexPath(row: 0, section: 0)) as? ItemCell
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_HasNameLabel() {
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }

    func test_ConfigCell_SetsTitle() {
        cell.configCell(with: ToDoItem(title: "Foo"))
        XCTAssertEqual(cell.titleLabel.text, "Foo")
    }

    func test_ConfigCell_SetsDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: "08/27/2017")
        let timestamp = date?.timeIntervalSince1970
        cell.configCell(with: ToDoItem(title: "Foo",
                                       timestamp: timestamp))
        XCTAssertEqual(cell.dateLabel.text, "08/27/2017")
    }

    func test_Title_WhenItemIsChecked_IsStrokeThrough() {
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo",
                            itemDescription: nil,
                            timestamp: 1456150025,
                            location: location)
        cell.configCell(with: item, checked: true)
        let attributedString = NSAttributedString(
            string: "Foo",
            attributes: [NSAttributedString.Key.strikethroughStyle:
                NSUnderlineStyle.single.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
}

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}

