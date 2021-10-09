//
//  
//  MarketPricesPresenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//
//

import Combine
import Foundation

struct MarketPricesPresenter: PresenterType {

    let inputFromInteractor = PassthroughSubject<MarketPricesInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<MarketPricesViewController.State, Never>()
    
    private let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
        bindInputOutput()
    }
}

// MARK: Internal

private extension MarketPricesPresenter {
    
    mutating func bindInputOutput() {
        inputFromInteractor
            .map { interactorResponse in
                switch interactorResponse {
                case .dummy: return MarketPricesViewController.State.dummy
                }
            }
            .subscribe(outputToViewController)
            .store(in: &bag)
    }
}
