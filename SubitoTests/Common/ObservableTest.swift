//
//  Observable.swift
//  SubitoTests
//
//  Created by Ariel Congestri on 14/12/2021.
//

import XCTest
@testable import Subito

class ObservableTest: XCTestCase {

    func test_observable_init() {
        let booleanObservable = Observable(true)
        XCTAssertTrue(booleanObservable.value)
    }

    func test_observable_observerNotification_newValueNotified() {
        let stringObservable = Observable("Old Value")
        var didValueChange = false
        let NewValueNotificationExpectation = expectation(description: "NewValueNotificationExpectation")
        stringObservable.observe(observer: self) {
            XCTAssert($0 == "New Value")
            XCTAssert($0 == stringObservable.value)
            XCTAssertTrue(didValueChange)
            NewValueNotificationExpectation.fulfill()
        }
        didValueChange = true
        stringObservable.value = "New Value"
        wait(for: [NewValueNotificationExpectation], timeout: 2.0)
    }

    func test_observable_observerNotification_initialValueNotified() {
        let stringObservable = Observable("Initial Value")
        let InitialValueNotificationExpectation = expectation(description: "InitialValueNotificationExpectation")
        stringObservable.observe(observer: self, shouldReadCurrent: true) {
            XCTAssert($0 == "Initial Value")
            XCTAssert($0 == stringObservable.value)
            InitialValueNotificationExpectation.fulfill()
        }
        wait(for: [InitialValueNotificationExpectation], timeout: 2.0)
    }

    func test_observable_observerNotification_observedNotNotified() {
        let stringObservable = Observable("Old Value")
        stringObservable.observe(observer: self) { _ in
            XCTFail("Removed observer Should not be notified")
        }
        stringObservable.remove(observer: self)
        stringObservable.value = "New Value"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssert(true)
        }
    }

}
