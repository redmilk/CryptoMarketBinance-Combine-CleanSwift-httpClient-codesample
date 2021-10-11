//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

struct MarketPricesConfigurator: ModuleLayersBinderType {
    let interactor: MarketPricesInteractor
    let presenter: MarketPricesPresenter
    let controller: MarketPricesViewController
}
