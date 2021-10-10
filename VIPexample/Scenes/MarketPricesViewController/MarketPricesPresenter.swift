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
            .map { [self] interactorResponse in
                switch interactorResponse {
                case .socketResponseModel(let model):
                    return .recievedResponseModel(model)
                case .socketResponseStatusMessage(let status, let shouldClean):
                    return .updateSocketStatus(status, shouldClean: shouldClean)
                case .socketResponseFail(let error):
                    return .failure(errorMessage: extractErrorMessage(fromError: error))
                }
            }
            .subscribe(outputToViewController)
            .store(in: &bag)
    }
    
    func extractErrorMessage(fromError error: BinanceServiceError) -> String {
        switch error {
        case .emptyStreamNames(let message):
            return message
        case .websocketClient(let socketInternalError):
            return (socketInternalError as NSError).localizedDescription
        }
    }
}
