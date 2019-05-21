//
//  InputViewControllerTests.swift
//  UnitTestDemoTests
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import XCTest
import CoreLocation
@testable import UnitTestDemo

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!

    var placemark: MockPlacemark!

    override func setUp() {
        sut = InputViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_HasTitleTextField() {
        let titleTextFieldIsSubView =
            sut.titleTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleTextFieldIsSubView)
    }

//    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let timestamp = 1456095600.0
//        let date = Date(timeIntervalSince1970: timestamp)
//
//        sut.titleTextField.text = "Foo"
//        sut.dateTextField.text = dateFormatter.string(from: date)
//        sut.locationTextField.text = "Bar"
//        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
//        sut.descriptionTextField.text = "Baz"
//
//        let mockGeocoder = MockGeocoder()
//        sut.geocoder = mockGeocoder
//        sut.itemManager = ItemManager()
//        sut.save()
//        placemark = MockPlacemark()
//        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
//        mockGeocoder.completionHandler?([placemark], nil)
//        let item = sut.itemManager?.item(at: 0)
//        let testItem = ToDoItem(title: "Foo",
//                                itemDescription: "Baz",
//                                timestamp: timestamp,
//                                location: Location(name: "Bar",
//                                                   coordinate: coordinate))
//        XCTAssertEqual(item, testItem)
//    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actions(
            forTarget: sut,
            forControlEvent: .touchUpInside) else {
                XCTFail(); return
        }
        XCTAssertTrue(actions.contains("save:"))
    }

    func test_Geocoder_FetchesCoordinates() {
        let geocoderAnswered = expectation(description: "Geocoder")

        let address = "Infinite Loop 1, Cupertino"

        CLGeocoder().geocodeAddressString(address) { (placemarks, error) -> Void in
            let coordinate = placemarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            XCTAssertEqual(latitude, 37.3316, accuracy: 0.001)
            XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)

            geocoderAnswered.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save(UIButton())
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
}

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {

        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(
            _ addressString: String,
            completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlacemark : CLPlacemark {

        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }

    class MockInputViewController : InputViewController {
        var dismissGotCalled = false
        override func dismiss(animated flag: Bool,
                              completion: (() -> Void)? = nil) {
            dismissGotCalled = true
        }
    }
}
