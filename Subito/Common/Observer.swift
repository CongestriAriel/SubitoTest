//
//  Observer.swift
//  Subito
//
//  Created by Ariel Congestri on 14/12/2021.
//

import Foundation

final class Observable<Value> {
    // MARK: - ObservationType
    enum ObservationType {
        case currentValues
        case newValue
    }

    // MARK: - Observer
    struct Observer<Value> {
        weak var observer: AnyObject?
        let notify: (Value) -> Void
    }

    // MARK: - Properties
    private var observers = [Observer<Value>]()
    public var value: Value {
        didSet { notifyObservers() }
    }

    // MARK: - Initializers
    public init(_ value: Value) {
        self.value = value
    }
    

    // MARK: - Public methods
    public func observe(observer: AnyObject,
                        shouldReadCurrent: Bool = false,
                        notify: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, notify: notify))
        if shouldReadCurrent {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                notify(self.value)
            }
        }
    }
    
    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
}
// MARK: - Private Methods
private extension Observable {
    private func notifyObservers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.observers.forEach { $0.notify(self.value) }
        }
    }
}

