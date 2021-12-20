//
//  StargazerDTO.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//

import Foundation

struct StargazerDTO: Codable {
    let avatarUrl: String?
    let login: String?

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login = "login"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        self.login  = try container.decode(String.self, forKey: .login)
    }

}
