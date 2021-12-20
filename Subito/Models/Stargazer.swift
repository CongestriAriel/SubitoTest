//
//  StargazersListViewData.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//

import Foundation

struct Stargazer {
    let imageURL: URL?
    let userName: String

    init(from dto: StargazerDTO) {
        imageURL = URL(string: dto.avatarUrl ?? "")
        userName = dto.login ?? "No Info"
    }
}
