//
//  NetworkingError.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//

import Foundation

struct NetworkingError: Error, Decodable {

    static var invalidRequestError: NetworkingError {
        return .init(description: "Please try again later, if the issue persist contact customer support.")
    }
    
    static var invalidResponseError: NetworkingError {
        return .init(description: "Please try again later, if the issue persist contact customer support.")
    }
    
    static var ServerError: NetworkingError {
        return .init(description: "You catch us in a bad state. Please try again later.")
    }
    var description: String
    
    private enum CodingKeys: String, CodingKey {
        case description = "message"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
    }

    init(description: String) {
        self.description = description
    }
}
