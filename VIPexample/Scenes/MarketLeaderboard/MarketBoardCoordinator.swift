//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketBoardCoordinatorType {
    func openDebugScene()
}

final class MarketBoardCoordinator: CoordinatorType, MarketBoardCoordinatorType {
    private let window: UIWindow
    private var navigationController: UINavigationController!
    private var configurator: MarketBoardConfigurator!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        var bag = Set<AnyCancellable>()
        let controller = MarketBoardViewController()
        let interactor = MarketBoardInteractor()
        let presenter = MarketBoardPresenter(coordinator: self, bag: &<#Set<AnyCancellable>#>)
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
    
    func openDebugScene() {
        end()
        let coordinator = MarketPricesCoordinator(window: window)
        coordinator.start()
    }
    
    func end() {
        /// nil the configurator to avoid memory leak
        configurator = nil
        window.rootViewController = nil
    }
}
