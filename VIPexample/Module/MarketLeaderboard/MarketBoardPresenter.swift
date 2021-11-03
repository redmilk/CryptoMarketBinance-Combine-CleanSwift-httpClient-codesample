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

final class MarketBoardPresenter: InputOutputable {
    typealias Failure = Never
    
    let input = PassthroughSubject<MarketBoardInteractor.Response, Never>()
    var output: AnyPublisher<MarketBoardViewController.State, Never> { _output.eraseToAnyPublisher() }
    
    private let coordinator: MarketBoardCoordinatorType
    private var bag = Set<AnyCancellable>()
    private let _output = PassthroughSubject<MarketBoardViewController.State, Never>()
    
    init(coordinator: MarketBoardCoordinatorType) {
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
        input.sink(receiveValue: { [unowned self] interactorResponse in
            switch interactorResponse {
            case .loading:
                _output.send(.loading)
            case .marketSymbolsTick(let marketData):
                _output.send(.newData(marketData))
            case .displayDebug: coordinator.displayDebug()
            case .displayMarvel: coordinator.displayMarvel()
            case .displayAuth: coordinator.displayAuthAsRoot()
            }
        })
        .store(in: &bag)
    }
}
