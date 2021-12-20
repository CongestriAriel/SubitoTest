//
//  StargazerSearchService.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//

import Foundation

class StargazersSearchService {
    // MARK: - Properties
    private var stargazersRepository: StargazersRepository

    // MARK: - Initializers
    init(stargazersRepository: StargazersRepository) {
        self.stargazersRepository = stargazersRepository
    }

    // MARK: - Public Methods
    func getStargazers(
        fromUser user: String,
        repositoryName: String,
        completion: @escaping (Result<[Stargazer], NetworkingError>) -> Void
    ) {
        stargazersRepository.getStargazers(
            fromUser: user,
            repositoryName: repositoryName,
            numberOfItems: 15,
            completion: completion)
    }
}
