//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketBoardCoordinatorType {
   
}

final class MarketBoardCoordinator: CoordinatorType, MarketBoardCoordinatorType {
    private let window: UIWindow
    private var navigationController: UINavigationController!
    private var configurator: MarketBoardConfigurator!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        print("Deinit Coordinator")
    }
    
    func start() {
        var bag = Set<AnyCancellable>()
        let controller = MarketBoardViewController()
        let interactor = MarketBoardInteractor()
        let presenter = MarketBoardPresenter(coordinator: self)
        configurator = MarketBoardConfigurator(
            controller: controller,
            interactor: interactor,
            presenter: presenter
        )
        configurator?.bindModuleLayers(controller: controller, bag: &bag)

        navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func end() {
        /// nil the configurator to avoid memory leak
        configurator = nil
        window.rootViewController = nil
    }
}
