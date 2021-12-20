//
//  Client.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//
import Foundation

class Client {
    
    // MARK: - Observer
    static let successRange = 200..<300
    static let redirectRange = 300..<400
    static let badRequestRange = 400..<500
    static let serverErrorRange = 500..<600
    let session = URLSession.shared
    #if DEBUG || INTERNAL
    static var mockResponsesEnabled = false
    #endif
    // MARK: - Public Methods
    
    /// This function will execute a call to API parse the response to the expected type and execute a completion
    /// - parameters:
    /// -request: The pre-configured request to execute
    /// -completion: Code to execute when the request ends
    /// It could return a NetworkingError
    /// or an object of the specified type
    func executeRequest<T: Decodable>(_ request: URLRequest, completion:  @escaping (Result<T,NetworkingError>) ->  Void) {
        #if DEBUG || INTERNAL
        if Client.mockResponsesEnabled {
            MockResponsesServer.shared.executeMockRequest(request) { [weak self] (responseData, response, responseError) in
                self?.handleResponse(
                    data: responseData,
                    response: response,
                    error: responseError,
                    completion: completion
                )
            }
            return
        }
        #endif
        let task = session.dataTask(with: request) { [weak self] (responseData, response, responseError) in
            self?.handleResponse(
                data: responseData,
                response: response,
                error: responseError,
                completion: completion
            )
        }
        task.resume()
    }
    
    func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion:  @escaping (Result<T,NetworkingError>) ->  Void) {
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponseError))
            return
        }
        /// This comment is only for correction purpose
        /// Even if the switch looks like it is doing the same for every error range
        /// I did not want to treat all error as the same
        /// it may not have sence in a little project but in a larger one it would be a good idea
        /// to log error and recognize all type of error
        /// I did not want to code a function that can only be used on this project.
        /// In a bigger project this may be part of an external library
        switch response.statusCode {
        case Client.successRange:
            guard let data = data,
                  let response = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.invalidResponseError))
                return
            }
            completion(.success(response))
        case Client.badRequestRange:
            guard let data = data,
                  let responseError = try? JSONDecoder().decode(NetworkingError.self, from: data) else {
                completion(.failure(.invalidResponseError))
                return
            }
            completion(.failure(responseError))
        case Client.serverErrorRange:
            completion(.failure(.ServerError))
        default:
            completion(.failure(.invalidResponseError))
        }
        
    }
}

