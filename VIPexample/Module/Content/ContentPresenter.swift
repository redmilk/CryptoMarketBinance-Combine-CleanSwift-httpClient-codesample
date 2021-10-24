//
//  ContentPresenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine

final class ContentPresenter: InputOutputable {
    typealias Failure = Never
    
    let input = PassthroughSubject<ContentInteractor.Response, Never>()
    var output: AnyPublisher<ContentViewController.State, Never> { _output.eraseToAnyPublisher() }

    private let _output = PassthroughSubject<ContentViewController.State, Never>()
    private let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
        
        input.sink(receiveValue: { [unowned self] interactorResponse in
                switch interactorResponse {
                case .showAuth: coordinator.end()
                case .character(let character):
                    guard let character = character else { return }
                    _output.send(.character(character))
                }
            })
            .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
