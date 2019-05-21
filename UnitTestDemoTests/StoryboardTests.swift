//
//  StoryboardTests.swift
//  UnitTestDemoTests
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import XCTest
@testable import UnitTestDemo

class StoryboardTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_InitialViewController_IsItemListViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let navigationController =
//            storyboard.instantiateInitialViewController()
//                as! UINavigationController
//        let rootViewController = navigationController.viewControllers[0]

        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
        let rootViewController = navigationController.viewControllers[0]
        XCTAssertTrue(rootViewController is ItemListViewController)
    }
}
