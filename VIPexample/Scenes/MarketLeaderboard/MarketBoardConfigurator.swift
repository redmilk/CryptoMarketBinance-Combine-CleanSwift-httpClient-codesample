//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UIViewController

final class MarketBoardConfigurator: ModuleLayersBinderType {
    let controller: MarketBoardViewController
    let interactor: MarketBoardInteractor
    let presenter: MarketBoardPresenter
    
    init(controller: MarketBoardViewController, interactor: MarketBoardInteractor, presenter: MarketBoardPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
    }
}
