//
//  ___HEADERFILE___
//

import Foundation
import Combine

final class MarketBoardInteractor: InputOutputable {
    typealias Failure = Never
    
    enum Response {
        case loading
        case marketSymbolsTick([MarketBoardSectionModel])
        case displayDebug
        case displayMarvel
        case displayAuth
    }
    
    let input = PassthroughSubject<MarketBoardViewController.Action, Never>()
    var output: AnyPublisher<Response, Never> { _output.eraseToAnyPublisher() }
    
    private let presenter: MarketBoardPresenter
    private let binanceWebSocketService: BinanceServiceWebSocketType
    private var bag = Set<AnyCancellable>()
    private let _output = PassthroughSubject<Response, Never>()
    
    init(presenter: MarketBoardPresenter,
         binanceWebSocketService: BinanceServiceWebSocketType
    ) {
        self.binanceWebSocketService = binanceWebSocketService
        self.presenter = presenter
        handleRequestFromController()
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: Internal

private extension MarketBoardInteractor {
    func handleRequestFromController() {
        input.sink(receiveValue: { [unowned self] action in
            switch action {
            case .shouldStartStream:
                connectToMarketStreams()
                _output.send(.loading)
            case .shouldDisconnect: binanceWebSocketService.disconnect()
            case .displayDebug: _output.send(.displayDebug)
            case .displayMarvel: _output.send(.displayMarvel)
            case .displayAuth: _output.send(.displayAuth)
            }
        })
        .store(in: &bag)
    }
    
    func connectToMarketStreams() {
        binanceWebSocketService.configure(withSingleOrMultipleStreams: ["!ticker@arr"])
        binanceWebSocketService.connect()
        _output.send(.loading)
        
        let handleSocketsResponse = binanceWebSocketService.subscribeSocketResponse().share()
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
                    let sections = self.binanceWebSocketService.buildMarketTopBySections(
                        allMarket: symbolTickerModels,
                        prefix: 20
                    )
                    self._output.send(.marketSymbolsTick(sections))
                case .failure(let error as NSError):
                    Logger.logError(error, descriptions: error.localizedDescription)
                }
            })
            .store(in: &bag)
    }
}
