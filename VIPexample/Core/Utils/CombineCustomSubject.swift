//
//  CombineCustomSubject.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 13.10.2021.
//

import Foundation
import Combine

class CustomSubject<Output, Failure: Error>: Subject {
    
    init(initialValue: Output, value: @escaping (Output) -> Output) {
        self.wrapped = .init(value(initialValue))
        self.value = value
    }

    func send(_ value: Output) {
        wrapped.send(self.value(value))
    }

    func send(completion: Subscribers.Completion<Failure>) {
        wrapped.send(completion: completion)
    }

    func send(subscription: Subscription) {
        wrapped.send(subscription: subscription)
    }

    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        wrapped.subscribe(subscriber)
    }

    private let wrapped: CurrentValueSubject<Output, Failure>
    private let value: (Output) -> Output
}
