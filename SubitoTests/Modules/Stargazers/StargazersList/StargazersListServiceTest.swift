//
//  StargazersListServiceTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 20/12/2021.
//

import XCTest
@testable import Subito

class StargazersListServiceTest: XCTestCase {

    func test_stargazersListService_getStargazers() {
        let client = Client()
        let service = StargazersListService(stargazersRepository: .init(client: client), repositoryName: "name", user: "user")
        Client.mockResponsesEnabled = true
        let firstExpectation = expectation(description: "StargazersListService first expectation")
        let secondExpectation = expectation(description: "StargazersListService second expectation")
        service.getStargazers(page: 1) { _ in
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 3.0)
        XCTAssertTrue(service.moreItemsAvailable)

        MockResponsesServer.shared.setMockResponse(.stargazersEmpty200)
        service.getStargazers(page: 2) { _ in
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 3.0)
        XCTAssertFalse(service.moreItemsAvailable)
    }
}
