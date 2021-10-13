//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

struct MarketBoardConfigurator: ModuleLayersBinderType {
    let interactor: MarketBoardInteractor
    let presenter: MarketBoardPresenter
    let controller: MarketBoardViewController
}
