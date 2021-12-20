//
//  StargazersSearchViewModelTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 20/12/2021.
//

import XCTest
@testable import Subito

class StargazersSearchViewModelTest: XCTestCase {

    let coordinator = StargazersSearchViewModelCoordinatorSpy()

    func test_stargazersSearchViewModel_clearFieldsButtonTitle() {
        let vm = getViewModel()
        XCTAssertEqual(vm.clearFieldsButtonTitle, "Clear Fields")
    }

    func test_stargazersSearchViewModel_getStargazersButtonTitle() {
        let vm = getViewModel()
        XCTAssertEqual(vm.getStargazersButtonTitle, "Get stargazes")
    }

    func test_stargazersSearchViewModel_repositoryTextFieldTile() {
        let vm = getViewModel()
        XCTAssertEqual(vm.repositoryTextFieldTile, "Repository name")
    }

    func test_stargazersSearchViewModel_repositoryTextFieldPlaceholder() {
        let vm = getViewModel()
        XCTAssertEqual(vm.repositoryTextFieldPlaceholder, "Example: hello-word")
    }

    func test_stargazersSearchViewModel_title() {
        let vm = getViewModel()
        XCTAssertEqual(vm.title, "Search Stargazers")
    }

    func test_stargazersSearchViewModel_userNameTextFieldPlaceholder() {
        let vm = getViewModel()
        XCTAssertEqual(vm.userNameTextFieldPlaceholder, "Example: octocat")
    }

    func test_stargazersSearchViewModel_userNameTextFieldTile() {
        let vm = getViewModel()
        XCTAssertEqual(vm.userNameTextFieldTile, "User name")
    }

    func test_stargazersSearchViewModel_shouldShowLoader() {
        Client.mockResponsesEnabled = true
        MockResponsesServer.shared.setDelay(9)
        let vm = getViewModel()
        let observeExpectation = expectation(description: "View Model observe expectation")
        vm.state.observe(observer: self) { t in
            observeExpectation.fulfill()
            vm.state.remove(observer: self)
        }
        vm.userNameDidChange("name")
        vm.repositoryNameDidChange("repo-name")
        vm.getStargazers()
        wait(for: [observeExpectation], timeout: 2)
        XCTAssertTrue(vm.shouldShowLoader)
    }

    func test_stargazersSearchViewModel_isGetStargazersButtonEnabled() {
        let vm = getViewModel()
        XCTAssertFalse(vm.isGetStargazersButtonEnabled.value)
        vm.userNameDidChange("name")
        vm.repositoryNameDidChange("repo name")
        XCTAssertTrue(vm.isGetStargazersButtonEnabled.value)
    }

    func test_stargazersSearchViewModel_clearFields() {
        let vm = getViewModel()
        XCTAssertFalse(vm.isGetStargazersButtonEnabled.value)
        vm.userNameDidChange("name")
        vm.repositoryNameDidChange("repo name")
        XCTAssertTrue(vm.isGetStargazersButtonEnabled.value)
        vm.clearFields()
        XCTAssertFalse(vm.isGetStargazersButtonEnabled.value)
    }

    func test_stargazersSearchViewModel_getStargazers() {
        let vm = getViewModel()
        coordinator.lastRepositoryName = nil
        coordinator.lastUser = nil

        vm.getStargazers()
        XCTAssertNil(coordinator.lastRepositoryName)
        XCTAssertNil(coordinator.lastUser)

        vm.userNameDidChange("name")
        vm.repositoryNameDidChange("repo-name")
        vm.getStargazers()
        MockResponsesServer.shared.setDelay(0)

        let resultExpectation = expectation(description: "Result Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            resultExpectation.fulfill()
        }
        wait(for: [resultExpectation], timeout: 3.0)
        XCTAssertEqual(coordinator.lastRepositoryName, "repo-name")
        XCTAssertEqual(coordinator.lastUser, "name")
    }
    

    private func getViewModel() -> StargazersSearchViewModel {
        let repository = StargazersRepository(client: .init())
        let service = StargazersSearchService(stargazersRepository: repository)
        return StargazersSearchViewModel(coordinator: coordinator, service: service)
    }
}

class StargazersSearchViewModelCoordinatorSpy: StargazersCoordinator {
    var lastRepositoryName: String?
    var lastUser: String?

    init() {
        super.init(client: .init())
    }

    override func goToStargazersList(repositoryName: String, user: String, stargazerList: [Stargazer]) {
        lastRepositoryName = repositoryName
        lastUser = user
    }
}

