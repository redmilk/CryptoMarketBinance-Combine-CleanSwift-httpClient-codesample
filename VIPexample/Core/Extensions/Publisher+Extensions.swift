//
//  Publisher+Extensions.swift
//  ReactiveMovies
//
//  Created by Danyl Timofeyev on 22.04.2021.
//

import Combine

extension Publisher where Self.Failure == Never {
    public func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Publisher {
    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
    
    static func just(output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
}


extension Publisher {
    func flatMapLatest<T: Publisher>(
        _ transform: @escaping (Self.Output) -> T
    ) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

// MARK: - Delay and Retry

extension Publisher {
    func delayAndRetry<S: Scheduler>(
        forInterval interval: S.SchedulerTimeType.Stride,
        scheduler: S,
        count: Int
    ) -> AnyPublisher<Self.Output, Self.Failure> {
        applyDelayAndRetry(upstream: self, forInterval: interval, scheduler: scheduler, count: count)
    }
    
    private func applyDelayAndRetry<Upstream: Publisher, S: Scheduler>(
        upstream: Upstream,
        forInterval interval: S.SchedulerTimeType.Stride,
        scheduler: S,
        count: Int
    ) -> AnyPublisher<Upstream.Output, Upstream.Failure> {
        Publishers.Share(upstream: upstream)
            .catch { _ in
                share.delay(for: interval, scheduler: scheduler)
            }
            .retry(count)
            .eraseToAnyPublisher()
    }
}
