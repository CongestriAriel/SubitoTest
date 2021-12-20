//
//  RequestBuilder.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//
import Foundation

struct RequestFactory {
    // MARK: - Properties

    /// The headers by default added to every request
    private var baseHeaders = ["Accept":"application/vnd.github.v3+json",
                               "Content-Type":"application/json"]

    /// This comment is for correction purpose only
    /// This is an  stored property because the baseURL
    /// could depend of the enviroment.
    private var baseURL: String {
        "https://api.github.com"
    }
    // MARK: - Public Methods

    /// This function is used to create URLRequest
    /// - parameters:
        /// -method: Representing the HTTPMethod
        /// -path: the path of the URL
        /// -body: The parameters to add in the request's body
        /// -headers: The headers to add for the request
            /// there are base headers added by default.
            /// if any header from the formal parameters
            /// the base headers would be overrided
    /// - returns
    /// -A  fully configured URLRequest
    func createRequest(
        method: HTTPMethod,
        path: String,
        parameters: [String:Any]? = nil,
        headers: [String:String]? = nil
    ) -> URLRequest? {
        var request: URLRequest
        switch method {
        case .get:
            guard let url = getURL(withQueryParameters: parameters, url: baseURL +  path) else {
                return nil
            }
            request = URLRequest(url: url)
        default:
            guard let url = URL(string: baseURL +  path) else { return nil }
            request = URLRequest(url: url)
            request.httpBody = serializedBody(parameters: parameters)
        }
        request.httpMethod = method.rawValue
        getHeaders(requestHeaders: headers).forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        return request
    }
}
// MARK: - Private Methods
private extension RequestFactory {
    func serializedBody(parameters: [String:Any]?) -> Data? {
        guard let parameters = parameters else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    func getHeaders(requestHeaders: [String:String]?) -> [String:String] {
        guard let requestHeaders = requestHeaders else { return baseHeaders }
        return requestHeaders.merging(baseHeaders) { current, _ in current }
    }

    func getURL(withQueryParameters parameters: [String:Any]?, url: String) -> URL? {
        guard let parameters = parameters else {
            return URL(string: url)
        }
        var urlComponent = URLComponents(string: url)
        urlComponent?.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        return urlComponent?.url
    }
}

