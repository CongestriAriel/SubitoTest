//
//  MockResponsesServer.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//
#if DEBUG || INTERNAL
import Foundation

class MockResponsesServer {
    // MARK: - Static Properties
    static var pathComponentSeparator: Character = "|"
    static var pathEndingIndicator = "^"
    static var methodEndingIndicator = "_"
    static var wildcatIndicator = "*"
    static var shared = MockResponsesServer()
    private var delay: DispatchTimeInterval = DispatchTimeInterval.seconds(0)

    // MARK: - Properties
    /// This is used to store all the mock responses that may
    /// or not return the default Response
    private var queue = [MockResponse]()
    /// This is used to store the default response for every different call
    /// should contain 1 mock response for each path and for each HTTTP method
    private var defaultMockResponses: [MockResponse] = [
        .stargazerSuccess200
    ]

    // MARK: - Public Methods
    /// This method add the received mock response to the queue
    func setMockResponse(_ response: MockResponse) {
        queue.append(response)
    }

    /// This method replicates the behaviour of URLSession.dataTask
    /// Would not going to the server to return any data
    /// Will initially  try to search for a queued MockResponse
    /// If it did not find any will pick the first one that matches from the default list
    /// - parameters:
    /// request: The URLRequest that needs to be executed
    /// -completion: Code to execute when the request ends
        /// Data: The data retrieved from the json located in the ResponsesFolder
        /// URLResponse: Response created from the MockResponse data
        /// Error: always return nil
    func executeMockRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            guard let mockResponse = self.getMockResponseFor(request: request),
                  let statusCode = mockResponse.statusCode,
                  let responseFile = Bundle.main.url(forResource: mockResponse.rawValue, withExtension: "json"),
                  let responseData = try? Data(contentsOf: responseFile),
                  let url = request.url else  {
                let description = "The MockResponse was created with errors, or was unable to parse"
                completion(nil, nil, NetworkingError(description: description))
                return
            }
            let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            completion(responseData,response, nil)
        }
    }
    
    // seconds after the response is sent. Only for testing purposes
    func setDelay(_ seconds: Int) {
        delay = DispatchTimeInterval.seconds(seconds)
    }
}
// MARK: - Private Methods
private extension MockResponsesServer {
    func getMockResponseFor(request: URLRequest) -> MockResponse? {
        if let response = queue.first(where: { compare(request, $0) }),
           let index = queue.firstIndex(of: response) {
            queue.remove(at: index)
            return response
        }
        return defaultMockResponses.first(where: { compare(request, $0) })
    }

    func compare(_ request: URLRequest, _ mockResponse: MockResponse) -> Bool {
        guard let mockResponseMethod = mockResponse.method?.rawValue,
              let requestURL = request.url else { return false }
        let areMethodsEquals = request.httpMethod == mockResponseMethod
        let areURLsEquals = comparePathComponents(
            requestURL.pathComponents,
            mockResponse.pathComponents
        )
        return areMethodsEquals && areURLsEquals
    }

    func comparePathComponents(_ requestPaths: [String], _ mockPaths: [String]) -> Bool  {
        guard requestPaths.count == mockPaths.count else { return false }
        let zippedPaths = zip(requestPaths, mockPaths)
        for (requestPath, mockPath) in zippedPaths {
            if mockPath != MockResponsesServer.wildcatIndicator && mockPath != requestPath {
                return false
            }
        }
        return true
    }
}
#endif
