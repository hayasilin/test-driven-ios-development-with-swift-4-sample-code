//
//  ApiClientTests.swift
//  UnitTestDemoTests
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import XCTest
@testable import UnitTestDemo

class ApiClientTests: XCTestCase {

    var sut: ApiClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        sut = ApiClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Login_UsesExpectedHost() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdom",
                      password: "1234",
                      completion: completion)

//        guard let url = mockURLSession.url else { XCTFail(); return }
//        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
    }

    func test_Login_UsesExpectedPath() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdom",
                      password: "1234",
                      completion: completion)

//        guard let url = mockURLSession.url else { XCTFail(); return }
//        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        XCTAssertEqual(urlComponents?.path, "/login")
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }

    func test_Login_UsesExpectedQuery() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasss@", password: "%&34", completion: completion)

        XCTAssertEqual(mockURLSession.urlComponents?.percentEncodedQuery, "username=dasss%40&password=%25%2634")
    }

    func test_Login_WhenSuccessful_CreatesToken() {
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonData,
                                        urlResponse: nil,
                                        error: nil)
        sut.session = mockURLSession
        let tokenExpectation = expectation(description: "Token")
        var caughtToken: Token? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { token, _
            in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken?.id, "1234567890")
        }
    }

    func test_Login_WhenJSONIsInvalid_ReturnsError() {

        let error = NSError(domain: "SomeError",
                            code: 1234,
                            userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonData,
                                        urlResponse: nil,
                                        error: error)
//        mockURLSession = MockURLSession(data: nil,
//                                        urlResponse: nil,
//                                        error: nil)
        sut.session = mockURLSession
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(catchedError)
        }
    }
}

extension ApiClientTests {

    class MockURLSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask


        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url,
                                 resolvingAgainstBaseURL: true)
        }

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data,
                                urlResponse: urlResponse,
                                error: error)
        }


        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            print(url)
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }

    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data

            self.urlResponse = urlResponse
            self.responseError = error
        }
        override func resume() {
            DispatchQueue.main.async() {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
}
