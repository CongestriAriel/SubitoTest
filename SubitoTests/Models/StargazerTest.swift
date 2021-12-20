//
//  StargazerTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 19/12/2021.
//

import XCTest
@testable import Subito

class StargazerTest: XCTestCase {

    func test_Stargazer_init() {
        let name = "ArielCongestri"
        let iconURL = URL(string: "https://avatars.githubusercontent.com/u/70?v=4")!
        let dto = getStargazerDTO(login: name, avatar_url: iconURL.absoluteString)
        let stargazer = Stargazer(from: dto)
        XCTAssertEqual(stargazer.userName, name)
        XCTAssertEqual(stargazer.imageURL, iconURL)
        
    }

    private func getStargazerDTO(login: String, avatar_url: String) -> StargazerDTO {
        let dictionary = ["login": "\(login)", "avatar_url": "\(avatar_url)"]
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return try! JSONDecoder().decode(StargazerDTO.self, from: data)
    }
}
