//
//  ItemListViewControllerTest.swift
//  UnitTestDemoTests
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import XCTest
@testable import UnitTestDemo

class ItemListViewControllerTest: XCTestCase {

    var sut: ItemListViewController!

    override func setUp() {
        sut = ItemListViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
    }

    func test_TableView_AfterViewDidLoad_IsNotNil() {
        XCTAssertNotNil(sut.tableView)
    }

    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }

    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func test_LoadingView_DataSourceEqualDelegate() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }

    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }

    func test_AddItem_PresentsAddItemViewController() {
        XCTAssertNil(sut.presentedViewController)
        UIApplication.shared.keyWindow?.rootViewController = sut
        guard let addButton = sut.navigationItem.rightBarButtonItem else
        { XCTFail(); return }
        guard let action = addButton.action else { XCTFail(); return }
        sut.performSelector(onMainThread: action,
                            with: addButton,
                            waitUntilDone: true)

        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)

        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }

    func testItemListVC_SharesItemManagerWithInputVC() {
        guard let addButton = sut.navigationItem.rightBarButtonItem else
        { XCTFail(); return }
        guard let action = addButton.action else { XCTFail(); return }
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action,
                            with: addButton,
                            waitUntilDone: true)
        guard let inputViewController =
            sut.presentedViewController as? InputViewController else
        { XCTFail(); return }
        guard let inputItemManager = inputViewController.itemManager else
        { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }

    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func testItemSelectedNotification_PushesDetailVC() {
        let mockNavigationController =
            MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController =
        mockNavigationController
        sut.loadViewIfNeeded()
        sut.itemManager.add(ToDoItem(title: "foo"))
        sut.itemManager.add(ToDoItem(title: "bar"))
        NotificationCenter.default.post(
            name: NSNotification.Name("ItemSelectedNotification"),
            object: self,
            userInfo: ["index": 1])
        guard let detailViewController = mockNavigationController
            .lastPushedViewController as? DetailViewController else {
                return XCTFail()
        }
        guard let detailItemManager = detailViewController.itemInfo?.0 else
        { return XCTFail() }
        guard let index = detailViewController.itemInfo?.1 else
        { return XCTFail() }
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
}

extension ItemListViewControllerTest {
    class MockNavigationController : UINavigationController {
        var lastPushedViewController: UIViewController?
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            lastPushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
