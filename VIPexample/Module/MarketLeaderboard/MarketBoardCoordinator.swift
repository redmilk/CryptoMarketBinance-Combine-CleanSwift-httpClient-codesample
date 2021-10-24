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
        let presenter = MarketBoardPresenter(coordinator: self, bag: &bag)
        let configurator = MarketBoardConfigurator()
        configurator.bindModuleLayers(controller: controller, interactor: interactor, presenter: presenter)

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
        window.rootViewController = nil
    }
}
