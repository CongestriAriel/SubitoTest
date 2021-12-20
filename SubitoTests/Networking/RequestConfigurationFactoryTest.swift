//
//  RequestConfigurationFactoryTest.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 14/12/2021.
//

import XCTest
@testable import Subito

class RequestConfigurationFactoryTest: XCTestCase {
    
    private let factory = RequestFactory()
    
    func test_RequestConfigurationFactory_createRequest_url() {
        let r = factory.createRequest(method: .get, path: "/test/url")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/test/url")
    }
    
    func test_RequestConfigurationFactory_createRequest_methodGet() {
        let r = factory.createRequest(method: .get, path: "/get/no/parameters")
        XCTAssert(r?.httpMethod == "GET")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/get/no/parameters")
    }
    
    func test_RequestConfigurationFactory_createRequest_methodPost() {
        let r = factory.createRequest(method: .post, path: "/post/no/parameters")
        XCTAssert(r?.httpMethod == "POST")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/no/parameters")
    }
    
    func test_RequestConfigurationFactory_createRequest_methodDelete() {
        let r = factory.createRequest(method: .delete, path: "/delete/no/parameters")
        XCTAssert(r?.httpMethod == "DELETE")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/delete/no/parameters")
    }
    
    func test_RequestConfigurationFactory_createRequest_methodPut() {
        let r = factory.createRequest(method: .put, path: "/put/no/parameters")
        XCTAssert(r?.httpMethod == "PUT")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/put/no/parameters")
    }
    
    func test_RequestConfigurationFactory_createRequest_emptyParameters() {
        let r = factory.createRequest(method: .post, path: "/post/no/parameters")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/no/parameters")
        XCTAssertNil(r?.httpBody)
    }
    
    func test_RequestConfigurationFactory_createRequest_parameters() {
        let parameters: [String:Any] = ["id": 78912,
                                        "customer": "Jason Sweet",
                                        "isSuperUser": true]
        let r = factory.createRequest(
            method: .post,
            path: "/post/parameters",
            parameters: parameters
        )
        let decodedBody = decode(data: r?.httpBody)
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/parameters")
        XCTAssert(decodedBody["id"] as? Int == 78912)
        XCTAssert(decodedBody["customer"] as? String == "Jason Sweet")
        XCTAssert(decodedBody["isSuperUser"] as? Bool == true)
    }
    
    func test_RequestConfigurationFactory_createRequest_emptyHeaders() {
        let r = factory.createRequest(method: .post, path: "/post/no/headers")
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/no/headers")
        XCTAssert(r?.value(forHTTPHeaderField: "Accept") == "application/vnd.github.v3+json")
        XCTAssert(r?.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
    
    func test_RequestConfigurationFactory_createRequest_overridingHeaders() {
        let r = factory.createRequest(
            method: .post,
            path: "/post/overriding/headers",
            headers: ["Accept":"newAcceptHeaderValue"])
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/overriding/headers")
        XCTAssert(r?.value(forHTTPHeaderField: "Accept") == "newAcceptHeaderValue")
        XCTAssert(r?.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
    
    func test_RequestConfigurationFactory_createRequest_newHeader() {
        let r = factory.createRequest(method: .post,
                                      path: "/post/new/headers",
                                      headers: ["newKey":"newKeyHeaderValue"])
        XCTAssert(r?.url?.absoluteString == "https://api.github.com/post/new/headers")
        XCTAssert(r?.value(forHTTPHeaderField: "Accept") == "application/vnd.github.v3+json")
        XCTAssert(r?.value(forHTTPHeaderField: "Content-Type") == "application/json")
        XCTAssert(r?.value(forHTTPHeaderField: "newKey") == "newKeyHeaderValue")
    }
    
    
    private func decode(data: Data?) -> [String:Any] {
        guard let data = data else { return [:] }
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
    }
}
