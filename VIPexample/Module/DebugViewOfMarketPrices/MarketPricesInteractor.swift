//
//  ___HEADERFILE___
//

import Foundation
import Combine

final class MarketPricesInteractor: InputOutputable, BinanceServiceProvidable {
    typealias Failure = Never
    
    enum Response {
        case socketResponseModel(AllStreamTickerTypes?)
        case socketResponseStatusMessage(String, shouldClean: Bool)
        case socketResponseFail(BinanceServiceError)
        case openMarvelScene
    }
    
    let input = PassthroughSubject<MarketPricesViewController.Action, Never>()
    var output: AnyPublisher<MarketPricesInteractor.Response, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()
    private let _output = PassthroughSubject<MarketPricesInteractor.Response, Never>()
    
    init() {
        handleInput()
        listenToSocketClientResponse()
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: Internal

private extension MarketPricesInteractor {
    func handleInput() {
        input.sink { [unowned self] action in
            switch action {
            case .configureSockets(let initialStreams): binanceService.configure(withSingleOrMultipleStreams: initialStreams)
            case .connect: binanceService.connect()
            case .disconnect: binanceService.disconnect()
            case .addStream(let streamNames): binanceService.updateStreams(updateType: .subscribe, forStreams: streamNames)
            case .removeStream(let streamNames): binanceService.updateStreams(updateType: .unsubscribe, forStreams: streamNames)
            case .reconnect: binanceService.reconnect()
            case .openMarvelScene:
                _output.send(.openMarvelScene)
            }
        }
        .store(in: &bag)
    }
    
    func listenToSocketClientResponse() {
        binanceService.subscribeSocketResponse()
            .map { [unowned self] socketResult in
                switch socketResult {
                case .connected: return Response.socketResponseStatusMessage("Connected", shouldClean: false)
                case .disconnected: return Response.socketResponseStatusMessage("Disconnected", shouldClean: true)
                case .error(let error): return Response.socketResponseFail(error)
                case .text(let textResponse):
                    let decoded = decodeSocketResponse(textResponse)
                    return Response.socketResponseModel(decoded)
                }
            }
            .sink(receiveValue: { [unowned self] in _output.send($0) })
            .store(in: &bag)
    }
    
    func decodeSocketResponse(_ response: String) -> AllStreamTickerTypes? {
        let data = Data(response.utf8)
        do {
            let model = try JSONDecoder().decode(AllStreamTickerTypes.self, from: data)
            return model
        } catch {
            Logger.logError(nil, descriptions: (error as NSError).localizedDescription)
            return nil
        }
    }
}
