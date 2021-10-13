//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

final class MarketPricesConfigurator: ModuleLayersBinderType {
    let controller: MarketPricesViewController
    let interactor: MarketPricesInteractor
    let presenter: MarketPricesPresenter

    init(controller: MarketPricesViewController, interactor: MarketPricesInteractor, presenter: MarketPricesPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
    }
}
