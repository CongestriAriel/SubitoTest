//
//  StargazersCoordinator.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//

import UIKit

class StargazersCoordinator {

    // MARK: - Properties
    private var navigationController: UINavigationController!
    private let stargazerRepository: StargazersRepository

    // MARK: - Initializers
    init(client: Client) {
        stargazerRepository = .init(client: client)
    }

    // MARK: - Public Methods
    func start() -> UIViewController {
        let service = StargazersSearchService(stargazersRepository: stargazerRepository)
        let viewModel = StargazersSearchViewModel(coordinator: self, service: service)
        let viewController = StargazersSearchViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func goToStargazersList(repositoryName: String, user: String, stargazerList: [Stargazer]) {
        let service = StargazersListService(
            stargazersRepository: stargazerRepository,
            repositoryName: repositoryName,
            user: user
        )
        let viewModel = StargazersListViewModel(service: service, stargazers: stargazerList)
        let viewController = StargazersListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
