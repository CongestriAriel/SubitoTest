//
//  StargazersListViewModel.swift
//  Subito
//
//  Created by Ariel Congestri on 19/12/2021.
//

import Foundation

final class StargazersListViewModel {

    // MARK: - Properties
    private var service: StargazersListService
    private var stargazers: [Stargazer]
    private var currentPage = 0
    private var itemsBeforeSearch = 5
    private(set) var state: Observable<ViewModelState> = .init(.success)

    // MARK: - Initializers
    init(service: StargazersListService, stargazers: [Stargazer] ) {
        self.service = service
        self.stargazers = stargazers
    }

    // MARK: - View Data Source
    var numberOfSections: Int {
      return 1
    }

    var title: String {
        return "Stargazers List"
    }

    var headerTitle: String {
        return state.value == .loading ? "Loading More Items": "Results: \(stargazers.count)"
    }

    func numberOfItems(forSections section: Int) -> Int{
        return stargazers.count
    }

    // MARK: - Public Methods
    func getItem(forIndexPath indexPath: IndexPath) -> Stargazer {
        if service.moreItemsAvailable,
           indexPath.row == stargazers.count - itemsBeforeSearch {
            fetchStargazers()
        }
        return stargazers[indexPath.row]
    }
}
// MARK: - Private Methods
private extension StargazersListViewModel {
    func fetchStargazers() {
        currentPage += 1
        state.value = .loading
        service.getStargazers(page: currentPage) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .success(stargazers):
                self.handleSuccess(stargazers)
            case let .failure(error):
                self.handleError(error: error)
            }
        }
    }

    func handleSuccess(_ stargazers: [Stargazer]) {
        self.stargazers.append(contentsOf: stargazers)
        state.value = .success
    }

    func handleError(error: NetworkingError) {
        let errorViewData = ErrorViewData(title: "Error", message: error.description)
        state.value = .failure(errorViewData)
    }
}
