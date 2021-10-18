//
//  ___HEADERFILE___
//

import Foundation
import Combine

final class MarketBoardInteractor: InteractorType, BinanceServiceProvidable {
    
    enum Response {
        case marketSymbolsTick([MarketBoardSectionModel])
        case openDebug
        case loading
    }
    
    let inputFromController = PassthroughSubject<MarketBoardViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        handleRequestFromController()
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: Internal

private extension MarketBoardInteractor {
    func handleRequestFromController() {
        inputFromController.sink(receiveValue: { [unowned self] action in
            switch action {
            case .streamStart:
                connectToMarketStreams()
            case .openDebug:
                outputToPresenter.send(.openDebug)
            }
        })
        .store(in: &bag)
    }
    
    func connectToMarketStreams() {
        let symbols = "btcusdt@ticker ethusdt@ticker adausdt@ticker shibusdt@ticker xrpusdt@ticker avaxusdt@ticker dogeusdt@ticker dotusdt@ticker bnbusdt@ticker atomusdt@ticker ftmusdt@ticker ltcusdt@ticker omgusdt@ticker linkusdt@ticker neousdt@ticker iotausdt@ticker kncusdt@ticker"
            .components(separatedBy: [" "]).filter { !$0.isEmpty }
        binanceService.configure(withSingleOrMultipleStreams: ["!ticker@arr"])
        binanceService.connect()
        outputToPresenter.send(.loading)
        
        let handleSocketsResponse = binanceService.subscribeSocketResponse().share()
        
        handleSocketsResponse
            .map({ binanceApiSocketResponse -> Data? in
                guard case .text(let socketTickData) = binanceApiSocketResponse else { return nil }
                return Data(socketTickData.utf8)
            })
            .compactMap { $0 }
            .decode(type: AllStreamTickerTypes.self, decoder: JSONDecoder())
            .map { allStreamTickerTypes -> Result<[SymbolTickerElement], Error>? in
                guard case .allMarketTicker(let allMarketSymbols) = allStreamTickerTypes else { return nil }
                return .success(allMarketSymbols)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .catch { Just(Result<[SymbolTickerElement], Error>.failure($0)) }
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let symbolTickerModels):
                    let sections = self.binanceService.buildMarketTopBySections(allMarket: symbolTickerModels, prefix: 20)
                    self.outputToPresenter.send(.marketSymbolsTick(sections))
                case .failure(let error as NSError):
                    Logger.logError(error, descriptions: error.localizedDescription)
                }
            })
            .store(in: &bag)
    }
}
