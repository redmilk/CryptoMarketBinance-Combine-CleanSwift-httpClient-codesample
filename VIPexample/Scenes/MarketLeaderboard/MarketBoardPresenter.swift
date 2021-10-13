//
//  
//  MarketBoardPresenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//
//

import Combine
import Foundation

final class MarketBoardPresenter: PresenterType {

    let inputFromInteractor = PassthroughSubject<MarketBoardInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<MarketBoardViewController.State, Never>()
    
    private let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
        handleInput()
    }
}

// MARK: Internal

private extension MarketBoardPresenter {
    
    func handleInput() {
        inputFromInteractor.sink(receiveValue: { [unowned self] interactorResponse in
            switch interactorResponse {
            case .marketSymbolsTick(let tickItems):
                outputToViewController.send(.newData(MarketBoardSectionModel(items: tickItems)))
            case .loading: break
            }
        })
        .store(in: &bag)
    }
}
