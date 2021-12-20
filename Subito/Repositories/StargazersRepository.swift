//
//  StargazersRepository.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//

import Foundation

class StargazersRepository {
    // MARK: - Properties
    private let factory = RequestFactory()
    let client: Client

    init(client: Client) {
        self.client = client
    }

    // MARK: - Public Methods
    func getStargazers(
        fromUser user: String,
        repositoryName: String,
        numberOfItems: Int,
        page: Int = 1,
        completion: @escaping (Result<[Stargazer], NetworkingError>) -> Void
    ) {
        guard let request = createGetStargazerRequest(
                fromUser: user,
                repositoryName: repositoryName,
                numberOfItems: numberOfItems,
                page: page
            ) else {
            completion(.failure(.invalidRequestError))
            return
        }
        let requestHandler: (Result<[StargazerDTO], NetworkingError>) -> Void = {
            switch $0 {
            case let .success(response):
                let list = response.map() { Stargazer(from: $0) }
                completion(.success(list))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        client.executeRequest(request, completion: requestHandler)
    }
}
// MARK: - Request Creation Methods
private extension StargazersRepository {
    func createGetStargazerRequest(
        fromUser user: String,
        repositoryName: String,
        numberOfItems: Int,
        page: Int
    ) -> URLRequest? {
        let path = "/repos/\(user)/\(repositoryName)/stargazers"
        return factory.createRequest(method: .get, path: path, parameters: ["per_page": numberOfItems, "page": page])
    }
}
