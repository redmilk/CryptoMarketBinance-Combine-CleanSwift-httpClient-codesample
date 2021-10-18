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
    
    private let coordinator: MarketBoardCoordinatorType
    private var bag: Set<AnyCancellable>
    
    init(coordinator: MarketBoardCoordinatorType, bag: inout Set<AnyCancellable>) {
        self.bag = bag
        self.coordinator = coordinator
        handleInput()
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: Internal

private extension MarketBoardPresenter {
    
    func handleInput() {
        inputFromInteractor.sink(receiveValue: { [unowned self] interactorResponse in
            switch interactorResponse {
            case .marketSymbolsTick(let marketData):
                outputToViewController.send(.newData(marketData))
            case .loading: break
            case .openDebug: coordinator.openDebugScene()
            }
        })
        .store(in: &bag)
    }
}
