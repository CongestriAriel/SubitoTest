//
//  MockResponseServerTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 19/12/2021.
//

import XCTest
@testable import Subito

class MockResponseServerTest: XCTestCase {

    func test_MockResponseServer_setMockResponse() {
        let client = Client()
        Client.mockResponsesEnabled = true
        MockResponsesServer.shared.setMockResponse(.stargazersInternalServerError500)
        let resultExpectation = expectation(description: "MockResponseServer expectation")
        let request = RequestFactory().createRequest(method: .get, path: "/repos/a/a/stargazers")!
        let completion: (Result<[StargazerDTO], NetworkingError>) -> Void = { result in
            guard case let .failure(error) = result else {
                XCTFail("The result must be a failure")
                return
            }
            XCTAssert(error.description == "You catch us in a bad state. Please try again later.")
            resultExpectation.fulfill()
        }
        client.executeRequest(request, completion: completion)
        wait(for: [resultExpectation], timeout: 3.0)
    }

    func test_mockResponseServer_executeRequest() {
        let client = Client()
        Client.mockResponsesEnabled = true
        MockResponsesServer.shared.setMockResponse(.stargazerSuccess200)
        let request = RequestFactory().createRequest(method: .get, path: "/repos/a/a/stargazers")!
        let expectedResult = getExpectedResultFor200()
        let resultExpectation = expectation(description: "MockResponseServer expectation")
        let completion: (Result<[StargazerDTO], NetworkingError>) -> Void =  { result in
            guard case let .success(response) = result else {
                XCTFail("The result must be a failure")
                return
            }
            XCTAssertEqual(expectedResult.count, response.count)
            XCTAssertEqual(expectedResult.first?.login, response.first?.login)
            resultExpectation.fulfill()
        }

        client.executeRequest(request, completion: completion)
        wait(for: [resultExpectation], timeout: 3.0)
    }

    private func getExpectedResultFor200() -> [StargazerDTO] {
        let bundle = Bundle(for: MockResponsesServer.self)
        guard let responseFile = bundle.url(forResource: "repos|*|*|stargazers^GET_Success200", withExtension: "json"),
              let responseData = try? Data(contentsOf: responseFile),
              let expectedResult = try? JSONDecoder().decode([StargazerDTO].self, from: responseData) else {
            fatalError("Response not found")
        }
        return expectedResult
    }
}
