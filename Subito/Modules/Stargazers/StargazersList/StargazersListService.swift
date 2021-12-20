//
//  StargazersListService.swift
//  Subito
//
//  Created by Ariel Congestri on 19/12/2021.
//

import Foundation


class StargazersListService {

    // MARK: - Properties
    private var numbersOfItems = 20
    private var stargazersRepository: StargazersRepository
    private var repositoryName: String
    private var user: String
    private(set) var moreItemsAvailable = true

    // MARK: - Initializers
    init(stargazersRepository: StargazersRepository, repositoryName: String, user: String) {
        self.repositoryName = repositoryName
        self.stargazersRepository = stargazersRepository
        self.user = user
    }

    // MARK: - Public Methods
    func getStargazers(
        page: Int,
        completion: @escaping (Result<[Stargazer], NetworkingError>) -> Void
    ) {
        stargazersRepository.getStargazers(
            fromUser: user,
            repositoryName: repositoryName,
            numberOfItems: numbersOfItems, page: page) { [weak self] in
            guard let self = self else {
                completion(.failure(.invalidRequestError))
                return
            }
            switch $0 {
            case let .success(response):
                self.moreItemsAvailable = response.count == self.numbersOfItems
                completion(.success(response))
            case let .failure(error):
                self.moreItemsAvailable = false
                completion(.failure(error))
            }
        }
    }
}
