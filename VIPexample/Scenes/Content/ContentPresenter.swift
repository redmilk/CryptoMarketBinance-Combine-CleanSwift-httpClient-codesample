//
//  ContentPresenter.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import Combine

final class ContentPresenter: ScenePresentable {
    
    // MARK: ScenePresentable implementation
    let inputFromInteractor = PassthroughSubject<ContentInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<ContentViewController.State, Never>()

    private let coordinator: Coordinatable
    private var subscriptions = Set<AnyCancellable>()
    
    required init(coordinator: Coordinatable) {
        self.coordinator = coordinator
        
        inputFromInteractor
            .sink(receiveValue: { [unowned self] interactorResponse in
                switch interactorResponse {
                case .closePressed: coordinator.end()
                case .character(let character):
                    guard let character = character else { return }
                    outputToViewController.send(.character(character))
                }
            })
            .store(in: &subscriptions)
    }
}
