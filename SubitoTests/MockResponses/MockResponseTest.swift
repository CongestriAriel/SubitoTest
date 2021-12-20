//
//  MockResponseTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 19/12/2021.
//

import XCTest
@testable import Subito

class MockResponseTest: XCTestCase {
    var response: MockResponse!

    func test_mockResponse_method() {
        response = .stargazerSuccess200
        XCTAssert(response.method == HTTPMethod.get)
    }

    func test_mockResponse_pathComponents() {
        response = .stargazerSuccess200
        let pathComponents = ["/","repos","*","*","stargazers"]
        XCTAssert(response.pathComponents == pathComponents)
    }

    func test_mockResponse_statusCode() {
        response = .stargazersInternalServerError500
        XCTAssert(response.statusCode == 500)
    }
}
