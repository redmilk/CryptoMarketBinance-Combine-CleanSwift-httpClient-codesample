//
//  ContentPresenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine

final class ContentPresenter: PresenterType {
    
    let inputFromInteractor = PassthroughSubject<ContentInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<ContentViewController.State, Never>()

    private let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: CoordinatorType, bag: inout Set<AnyCancellable>) {
        self.coordinator = coordinator
        
        inputFromInteractor
            .sink(receiveValue: { [unowned self] interactorResponse in
                switch interactorResponse {
                case .showAuth: coordinator.end()
                case .character(let character):
                    guard let character = character else { return }
                    outputToViewController.send(.character(character))
                }
            })
            .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
