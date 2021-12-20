//
//  StargazersRepositoryTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 19/12/2021.
//

import XCTest
@testable import Subito

class StargazersRepositoryTest: XCTestCase {

    func test_stargazersRepository_getStargazers() {
        let client = StargazersRepositoryClientSpy()
        Client.mockResponsesEnabled = true
        let repository = StargazersRepository(client: client)
        let expectedURL = "https://api.github.com/repos/ArielCongestri/subito/stargazers?per_page=10&page=3"
        let expectationResult = expectation(description: "expectation for StargazersRepository")
        repository.getStargazers(fromUser: "ArielCongestri", repositoryName: "subito", numberOfItems: 10, page: 3) { _ in
            XCTAssertEqual(expectedURL, client.lastRequest?.url?.absoluteString)
            XCTAssertEqual(1, client.numberOfExecutions)
            expectationResult.fulfill()
        }
        wait(for: [expectationResult], timeout: 3.0)
    }
}

class StargazersRepositoryClientSpy: Client {
    var lastRequest: URLRequest?
    var numberOfExecutions = 0
    
    override func executeRequest<T>(_ request: URLRequest, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable {
        lastRequest = request
        numberOfExecutions += 1
        completion(.failure(.ServerError))
    }
}
