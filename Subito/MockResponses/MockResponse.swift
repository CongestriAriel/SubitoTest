//
//  MockResponse.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//
#if DEBUG || INTERNAL
import Foundation

enum MockResponse: String {
    // MARK: - Cases
    /// All posibles responses must be listed here
    /// Delete the first "\" and replace "/" with "|" from the URL
    /// Add ^(HTTTPMETHOD-CAPITALIZED)_
    /// Add description off the response
    /// Add HTTPStatusCode
    /// Use "*" for URL parameters
    /// - Explanation:
        /// path|*|path2^HTTTPMETHOD-CAPITALIZED_XXX
    case stargazerSuccess200 = "repos|*|*|stargazers^GET_Success200"
    case stargazersEmpty200 = "repos|*|*|stargazers^GET_Empty200"
    case stargazersNotFound400 = "repos|*|*|stargazers^GET_NotFound400"
    case stargazersInternalServerError500 = "repos|*|*|stargazers^GET_InternalServerError500"
}
// MARK: - Stored Properties
extension MockResponse {

    /// This property returns the HTTPMethod of the response
    var method: HTTPMethod? {
        guard let initialIndex = self.rawValue.range(of: MockResponsesServer.pathEndingIndicator)?.upperBound,
              let endingIndex = self.rawValue.range(of: MockResponsesServer.methodEndingIndicator)?.lowerBound else {
            return nil
        }
        return HTTPMethod(rawValue: String(self.rawValue[initialIndex..<endingIndex]))
    }

    /// This property replicates the behaviour of
    /// URLRequest.pathComponents
    var pathComponents: [String] {
        guard let index = self.rawValue.range(of: MockResponsesServer.pathEndingIndicator)?.lowerBound else {
            return ["/"]
        }
        let path = String(self.rawValue.prefix(upTo: index))
        let urlComponents = path.split(separator: MockResponsesServer.pathComponentSeparator).map { String($0) }
        return ["/"] + urlComponents
    }

    /// This property returns the StatusCode of the response
    var statusCode: Int? {
        Int(String(self.rawValue.suffix(3)))
    }
}
#endif
