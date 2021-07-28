//
//  Publisher+Extensions.swift
//  Clawee
//
//  Created by Danyl Timofeyev on 11.05.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import Combine

extension Publisher {
    
    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error)
            .eraseToAnyPublisher()
    }
    
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}
