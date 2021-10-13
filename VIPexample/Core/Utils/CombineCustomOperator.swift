//
//  CombineCustomOperator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 13.10.2021.
//

import Foundation
import Combine

extension Publisher {
    func customOperator() -> CustomOperator<Self> {
        return CustomOperator(upstream: self)
    }
}

struct CustomOperator<Upstream: Publisher>: Publisher {
    typealias Output = Upstream.Output
    typealias Failure = Upstream.Failure
    private let upstream: Upstream
    
    init(upstream: Upstream) {
        self.upstream = upstream
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
        upstream.subscribe(Inner(downstream: subscriber))
    }
    
    final class Inner<S: Subscriber, Input>: Subscriber, Subscription
    where S.Failure == Failure, S.Input == Input {
        
        private var downstream: S?
        private var upstream: Subscription?
        
        init(downstream: S) {
            self.downstream = downstream
        }
        
        // MARK: - Subscriber implementation
        
        func receive(subscription: Subscription) {
            upstream = subscription
            downstream?.receive(subscription: self)
        }

        func receive(_ input: Input) -> Subscribers.Demand {
            downstream?.receive(input) ?? .max(0)
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            downstream?.receive(completion: completion)
            downstream = nil
            upstream = nil
        }
        
        // MARK: - Subscription implementation

        func request(_ demand: Subscribers.Demand) {
            upstream?.request(demand)
        }

        func cancel() {
            upstream?.cancel()
            upstream = nil
            downstream = nil
        }
    }
}
