//
//  ___HEADERFILE___
//

import Foundation
import Combine

struct MarketPricesInteractor: InteractorType, BinanceServiceProvidable {
    
    enum Response {
        case socketResponseText(String)
        case socketResponseStatusMessage(String)
        case socketResponseFail(Error)
    }
    
    let inputFromController = PassthroughSubject<MarketPricesViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        bindInput()
        listenToSocketClientResponse()
    }
}

// MARK: Internal

private extension MarketPricesInteractor {
    mutating func bindInput() {
        inputFromController.sink { [self] action in
            switch action {
            case .configureSockets(let initialStreams): binanceService.configure(withSingleOrMultipleStreams: initialStreams)
            case .connect: binanceService.connect()
            case .disconnect: binanceService.disconnect()
            case .addStream(let streamNames): binanceService.updateStreams(updateType: .subscribe, forStreams: streamNames)
            case .removeStream(let streamNames): binanceService.updateStreams(updateType: .unsubscribe, forStreams: streamNames)
            case .reconnect: binanceService.reconnect()
            }
        }
        .store(in: &bag)
    }
    
    mutating func listenToSocketClientResponse() {
        binanceService.subscribeSocketResponse()
            .map { socketResult in
                switch socketResult {
                case .connected: return Response.socketResponseText("Connected")
                case .disconnected: return Response.socketResponseText("Disconnected")
                case .error(let error): return Response.socketResponseFail(error)
                case .message(let message): return Response.socketResponseStatusMessage(message)
                }
            }
            .sink(receiveValue: { [self] in outputToPresenter.send($0) })
            .store(in: &bag)
    }
}
