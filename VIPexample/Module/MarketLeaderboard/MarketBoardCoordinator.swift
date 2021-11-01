//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketBoardCoordinatorType {
    func displayDebug()
    func displayMarvel()
}

final class MarketBoardCoordinator: CoordinatorType, MarketBoardCoordinatorType {
    private unowned let window: UIWindow
    private var navigation: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let presenter = MarketBoardPresenter(coordinator: self)
        let interactor = MarketBoardInteractor(presenter: presenter)
        let controller = MarketBoardViewController(interactor: interactor)
        let configurator = MarketBoardConfigurator()
        let bag = configurator.bindModuleLayers(controller: controller, interactor: interactor, presenter: presenter)
        controller.setupWithDisposableBag(bag)
        navigation = DarkNavigationController(rootViewController: controller)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func displayDebug() {
        let coordinator = MarketPricesCoordinator(navigation: navigation)
        coordinator.start()
    }
    
    func displayMarvel() {
        let coordinator = ContentCoordinator(navigation: navigation)
        coordinator.start()
    }
    
    func openAuthAsRoot() {
        
    }
    
    func end() {
        window.rootViewController = nil
    }
}
