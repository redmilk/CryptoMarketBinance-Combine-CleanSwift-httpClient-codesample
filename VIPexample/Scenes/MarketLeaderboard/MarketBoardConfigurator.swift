//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

import Combine

final class MarketBoardConfigurator: ModuleLayersBinderType {
    func bindModuleLayers(controller: MarketBoardViewController, bag: inout Set<AnyCancellable>) {
        
    }
    
    let controller: MarketBoardViewController
    let interactor: MarketBoardInteractor
    let presenter: MarketBoardPresenter
    
    init(controller: MarketBoardViewController, interactor: MarketBoardInteractor, presenter: MarketBoardPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
