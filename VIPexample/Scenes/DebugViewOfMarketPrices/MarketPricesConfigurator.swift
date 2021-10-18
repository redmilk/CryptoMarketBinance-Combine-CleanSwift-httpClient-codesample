//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

import Combine

final class MarketPricesConfigurator: ModuleLayersBinderType {
    func bindModuleLayers(controller: MarketPricesViewController, bag: inout Set<AnyCancellable>) {
        
    }
    
    let controller: MarketPricesViewController
    let interactor: MarketPricesInteractor
    let presenter: MarketPricesPresenter

    init(controller: MarketPricesViewController, interactor: MarketPricesInteractor, presenter: MarketPricesPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
