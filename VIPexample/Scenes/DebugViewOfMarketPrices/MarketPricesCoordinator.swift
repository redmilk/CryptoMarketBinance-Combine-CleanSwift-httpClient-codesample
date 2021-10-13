//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketPricesCoordinatorType {
   
}

final class MarketPricesCoordinator: CoordinatorType, MarketPricesCoordinatorType {
    private let window: UIWindow
    private var navigationController: UINavigationController!
    private var configurator: MarketPricesConfigurator!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        print("Deinit Coordinator")
    }
    
    func start() {
        var bag = Set<AnyCancellable>()
        let controller = MarketPricesViewController()
        let interactor = MarketPricesInteractor()
        let presenter = MarketPricesPresenter(coordinator: self)
        configurator = MarketPricesConfigurator(
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
