//
//  StargazersListViewModelTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 19/12/2021.
//

import XCTest
@testable import Subito

class StargazersListViewModelTest: XCTestCase {
    let client = Client()

    func test_stargazersListViewModelTest_numberOfSections() {
        let vm = getViewModel(stargazers: [])
        XCTAssertEqual(vm.numberOfSections, 1)
    }

    func test_stargazersListViewModelTest_title() {
        let vm = getViewModel(stargazers: [])
        XCTAssertEqual(vm.title, "Stargazers List")
    }

    func test_stargazersListViewModelTest_headerTitle() {
        let vm = getViewModel(stargazers: [])
        XCTAssertEqual(vm.headerTitle, "Results: \(0)")
        vm.setLoading()
        XCTAssertEqual(vm.headerTitle, "Loading More Items")
    }

    func test_stargazersListViewModelTest_numberOfItems() {
        let stargazers = getStargazers()
        let vm = getViewModel(stargazers: stargazers)
        XCTAssertEqual(vm.numberOfItems(forSections: 0), stargazers.count)
    }

    func test_stargazersListViewModelTest_getItemForIndexPath_result() {
        let stargazers = getStargazers()
        let vm = getViewModel(stargazers: stargazers)
        XCTAssertEqual(vm.getItem(forIndexPath: IndexPath(item: 0, section: 0)).userName, "user")
        XCTAssertEqual(vm.getItem(forIndexPath: IndexPath(item: 0, section: 0)).imageURL?.absoluteString, "https://www.google.com/")
    }

    func test_stargazersListViewModelTest_getItemForIndexPath_fetchNextPage_serviceMoreItemsAvailables() {
        let stargazers = getStargazers()
        let vm = getViewModel(stargazers: stargazers)
        var states = [ViewModelState]()
        Client.mockResponsesEnabled = true
        MockResponsesServer.shared.setDelay(1)
        let firstExpectation = expectation(description: "ViewModel observe first Expectation")
        let secondExpectation = expectation(description: "ViewModel observe second Expectation")
        vm.state.observe(observer: self) {
            states.append($0)
            if states.count == 2 {firstExpectation.fulfill()}
            if states.count == 4 {secondExpectation.fulfill()}
        }
        _ = vm.getItem(forIndexPath: IndexPath(item: stargazers.count - 5, section: 0))
        wait(for: [firstExpectation], timeout: 3.0)
        XCTAssertEqual(states, [.loading, .success])

        let item = stargazers.count + 20 - 5 // 20 additionals from fetch
        _ = vm.getItem(forIndexPath: IndexPath(item: item, section: 0))
        wait(for: [secondExpectation], timeout: 3.0)
        XCTAssertEqual(states, [.loading, .success, .loading, .success])
    }

    func test_stargazersListViewModelTest_getItemForIndexPath_fetchNextPage_serviceNoMoreItemsAvailables() {
        let stargazers = getStargazers()
        let vm = getViewModel(stargazers: stargazers)
        var states = [ViewModelState]()
        Client.mockResponsesEnabled = true
        MockResponsesServer.shared.setMockResponse(.stargazersEmpty200)
        MockResponsesServer.shared.setDelay(1)
        let firstExpectation = expectation(description: "ViewModel observe first Expectation")
        let secondExpectation = expectation(description: "ViewModel observe second Expectation")
        vm.state.observe(observer: self) {
            states.append($0)
            if states.count == 2 {firstExpectation.fulfill()}
        }
        _ = vm.getItem(forIndexPath: IndexPath(item: stargazers.count - 5, section: 0))
        wait(for: [firstExpectation], timeout: 3.0)
        XCTAssertEqual(states, [.loading, .success])

        _ = vm.getItem(forIndexPath: IndexPath(item: stargazers.count - 5, section: 0))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 3.0)
        XCTAssertEqual(states, [.loading, .success])
    }

    private func getViewModel(stargazers: [Stargazer]) -> StargazersListViewModel {
        let repository = StargazersRepository(client: client)
        let service = StargazersListService(stargazersRepository: repository, repositoryName: "name", user: "user")
        return StargazersListViewModel(service: service, stargazers: stargazers)
    }

    private func getStargazers() -> [Stargazer] {
        let dictionary = ["login": "user", "avatar_url": "https://www.google.com/"]
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        let stargazer =  Stargazer(from: (try! JSONDecoder().decode(StargazerDTO.self, from: data)))
        return [stargazer, stargazer, stargazer, stargazer, stargazer, stargazer]
    }
}

extension StargazersListViewModel {
    func setLoading() {
        state.value = .loading
    }
}
