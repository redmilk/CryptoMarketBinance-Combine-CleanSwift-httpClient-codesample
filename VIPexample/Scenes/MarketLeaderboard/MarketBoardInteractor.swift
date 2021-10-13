//
//  ___HEADERFILE___
//

import Foundation
import Combine

struct MarketBoardInteractor: InteractorType {
    
    enum Response {
        case dummy
    }
    
    let inputFromController = PassthroughSubject<MarketBoardViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        bindInputOutput()
    }
}

// MARK: Internal

private extension MarketBoardInteractor {
    mutating func bindInputOutput() {
        inputFromController.map { [self] action in
            switch action {
            case .streamStart: return .dummy
            }
        }
        .subscribe(outputToPresenter)
        .store(in: &bag)
    }
}
