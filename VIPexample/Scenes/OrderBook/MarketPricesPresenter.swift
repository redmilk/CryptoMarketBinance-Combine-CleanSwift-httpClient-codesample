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
        bindInput()
    }
}

// MARK: Internal

private extension MarketPricesPresenter {
    
    mutating func bindInput() {
        inputFromInteractor
            .map { interactorResponse in
                switch interactorResponse {
                case .socketResponseText(let text): return .updateMainText(text)
                case .socketResponseStatusMessage(let status): return .updateMainText(status)
                case .socketResponseFail(let error): return .showError(error)
                }
            }
            .subscribe(outputToViewController)
            .store(in: &bag)
    }
}
