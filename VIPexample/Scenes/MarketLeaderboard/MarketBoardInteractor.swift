//
//  ___HEADERFILE___
//

import Foundation
import Combine

final class MarketBoardInteractor: InteractorType, BinanceServiceProvidable {
    
    enum Response {
        case marketSymbolsTick([SymbolTickerElement])
        case loading
    }
    
    let inputFromController = PassthroughSubject<MarketBoardViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        handleRequestFromController()
    }
}

// MARK: Internal

private extension MarketBoardInteractor {
    func handleRequestFromController() {
        inputFromController.sink(receiveValue: { [unowned self] action in
            switch action {
            case .streamStart:
                connectToMarketStreams()
            }
        })
        .store(in: &bag)
    }
    
    func connectToMarketStreams() {
        let symbols = "btcusdt@ticker ethusdt@ticker adausdt@ticker shibusdt@ticker xrpusdt@ticker avaxusdt@ticker dogeusdt@ticker dotusdt@ticker bnbusdt@ticker atomusdt@ticker ftmusdt@ticker ltcusdt@ticker omgusdt@ticker linkusdt@ticker neousdt@ticker iotausdt@ticker kncusdt@ticker"
            .components(separatedBy: [" "]).filter { !$0.isEmpty }
        binanceService.configure(withSingleOrMultipleStreams: symbols)
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
            .sink(receiveValue: { [unowned self] result in
                switch result {
                case .success(let symbolTickerModels):
                    outputToPresenter.send(.marketSymbolsTick(symbolTickerModels))
                case .failure(let error as NSError):
                    Logger.logError(error, descriptions: error.localizedDescription)
                }
            })
            .store(in: &bag)
    }
}
