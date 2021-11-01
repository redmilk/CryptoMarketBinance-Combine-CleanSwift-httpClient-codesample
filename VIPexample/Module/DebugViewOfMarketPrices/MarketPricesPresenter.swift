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

final class MarketPricesPresenter: InputOutputable {
    typealias Failure = Never
    
    let input = PassthroughSubject<MarketPricesInteractor.Response, Never>()
    var output: AnyPublisher<MarketPricesViewController.State, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private let _output = PassthroughSubject<MarketPricesViewController.State, Never>()
    private let coordinator: MarketPricesCoordinatorType
    private let formatter = BinanceResponseModelsFormatter()
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: MarketPricesCoordinatorType) {
        self.coordinator = coordinator
        handleInput()
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: Internal

private extension MarketPricesPresenter {
    
    func handleInput() {
        input.sink(receiveValue: { [unowned self] interactorResponse in
                switch interactorResponse {
                case .socketResponseModel(let model):
                    let preparedDataForView = prepareDataForViewController(model)
                    guard let preparedData = preparedDataForView else { return }
                    _output.send(.recievedPreparedTextData(text: preparedData))
                case .socketResponseStatusMessage(let status, let shouldClean):
                    _output.send(.updateSocketStatus(newStatus: status, shouldCleanView: shouldClean))
                case .socketResponseFail(let error):
                    _output.send(.failure(errorDescription: extractErrorMessage(fromError: error), shouldCleanView: false))
                case .openMarvelScene:
                    coordinator.openMarvelScene()
                }
            })
            .store(in: &bag)
    }
    
    // MARK: - Prepare data for ViewController's needed format
    
    func prepareDataForViewController(_ model: AllStreamTickerTypes?) -> String? {
        guard let model = model else { return nil }
        switch model {
        case .singleSymbol(let singleSymbolModel):
            return formatter.formatSingleSymbolTickerElement(singleSymbolModel)
        case .multipleSymbols(let multipleSymbolModel):
            return formatter.formatMultipleSymbolsResponse(multipleSymbolModel)
        case .allMarketMiniTicker(let allMarketMiniTicker):
            return formatter.formatAllMarketMiniTickerElements(allMarketMiniTicker)
        case .allMarketTicker(let allMarket):
            return allMarket.count.description
        case .singleSymbolMini(_): return ""
        case .multipleSymbolsMini(_): return ""
        }
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
