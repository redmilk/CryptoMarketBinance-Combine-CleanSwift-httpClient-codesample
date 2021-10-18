//
//  ___HEADERFILE___
//

import Foundation
import Combine

final class MarketPricesInteractor: InteractorType, BinanceServiceProvidable {
    
    enum Response {
        case socketResponseModel(AllStreamTickerTypes?)
        case socketResponseStatusMessage(String, shouldClean: Bool)
        case socketResponseFail(BinanceServiceError)
        case openMarvelScene
    }
    
    let inputFromController = PassthroughSubject<MarketPricesViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
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
        inputFromController
            .sink { [unowned self] action in
            switch action {
            case .configureSockets(let initialStreams): binanceService.configure(withSingleOrMultipleStreams: initialStreams)
            case .connect: binanceService.connect()
            case .disconnect: binanceService.disconnect()
            case .addStream(let streamNames): binanceService.updateStreams(updateType: .subscribe, forStreams: streamNames)
            case .removeStream(let streamNames): binanceService.updateStreams(updateType: .unsubscribe, forStreams: streamNames)
            case .reconnect: binanceService.reconnect()
            case .openMarvelScene:
                outputToPresenter.send(.openMarvelScene)
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
            .sink(receiveValue: { [unowned self] in outputToPresenter.send($0) })
            .store(in: &bag)
    }
    
    func decodeSocketResponse(_ response: String) -> AllStreamTickerTypes? {
        //Logger.log(response, type: .responses)
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
