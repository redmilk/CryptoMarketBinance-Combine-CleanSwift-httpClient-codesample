//
//  ___HEADERFILE___
//

import Foundation
import Combine

struct MarketPricesInteractor: InteractorType {
    
    enum Response {
        case dummy
    }
    
    let inputFromController = PassthroughSubject<MarketPricesViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        bindInputOutput()
    }
}

// MARK: Internal

private extension MarketPricesInteractor {
    mutating func bindInputOutput() {
        inputFromController.map { [self] action in
            switch action {
            case .dummy: return Response.dummy
            }
        }
        .subscribe(outputToPresenter)
        .store(in: &bag)
    }
}
