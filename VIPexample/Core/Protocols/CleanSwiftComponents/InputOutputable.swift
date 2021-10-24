//
//  InputOutputable.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 24.10.2021.
//

import Combine

protocol InputOutputable: class {
    associatedtype Input
    associatedtype Output
    associatedtype Failure where Failure == Never
    
    var output: AnyPublisher<Output, Failure> { get }
    var input: PassthroughSubject<Input, Failure> { get }
}
