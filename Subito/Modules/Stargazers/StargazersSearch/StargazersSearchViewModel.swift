//
//  StargazersSearchViewModel.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//

import Foundation

final class StargazersSearchViewModel {
    
    // MARK: - Properties
    private let coordinator: StargazersCoordinator
    private let service: StargazersSearchService
    private var repositoryName: String?
    private var userName: String?
    private(set) var state: Observable<ViewModelState> = .init(.success)
    private(set) var isGetStargazersButtonEnabled: Observable<Bool> = .init(false)

    init(coordinator: StargazersCoordinator, service: StargazersSearchService) {
        self.coordinator = coordinator
        self.service = service
    }

}
// MARK: - View Data Source
extension StargazersSearchViewModel {

    var clearFieldsButtonTitle: String {
        return "Clear Fields"
    }
    var getStargazersButtonTitle: String {
        return "Get stargazes"
    }

    var repositoryTextFieldTile: String {
        return "Repository name"
    }

    var repositoryTextFieldPlaceholder: String {
        return "Example: hello-word"
    }

    var title: String {
        return "Search Stargazers"
    }

    var userNameTextFieldPlaceholder: String {
        return "Example: octocat"
    }

    var userNameTextFieldTile: String {
        return "User name"
    }

    var shouldShowLoader: Bool {
        return state.value == ViewModelState.loading
    }

    func clearFields() {
        repositoryName = nil
        userName = nil
        setGetStargazersButtonStatus()
    }
    
    func getStargazers() {
        guard let userName = userName,
              !userName.isEmpty,
              let repositoryName = repositoryName,
              !repositoryName.isEmpty else { return }
        state.value = .loading
        service.getStargazers(fromUser: userName, repositoryName: repositoryName) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .success(response):
                self.handleGetStargazersSuccess(response: response)
            case let .failure(error):
                self.handleGetStargazersFailure(error: error)
            }
        }
    }
    
    func repositoryNameDidChange(_ repositoryName: String?) {
        self.repositoryName = repositoryName
        setGetStargazersButtonStatus()
    }

    func userNameDidChange(_ userName: String?) {
        self.userName = userName
        setGetStargazersButtonStatus()
    }

}
// MARK: - Private Methods
private extension StargazersSearchViewModel {
    func handleGetStargazersSuccess(response: [Stargazer]) {
        state.value = .success
        guard let repositoryName = repositoryName,
              let userName = userName else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.coordinator.goToStargazersList(repositoryName: repositoryName, user: userName, stargazerList: response)
        }
    }

    func handleGetStargazersFailure(error: NetworkingError) {
        let errorViewData = ErrorViewData(title: "Error", message: error.description)
        state.value = .failure(errorViewData)
    }

    func setGetStargazersButtonStatus() {
        isGetStargazersButtonEnabled.value = !((userName?.isEmpty ?? true) || (repositoryName?.isEmpty ?? true))
    }
}

