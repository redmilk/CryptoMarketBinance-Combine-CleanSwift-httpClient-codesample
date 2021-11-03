//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketBoardCoordinatorType {
    func displayDebug()
    func displayMarvel()
    func displayAuthAsRoot()
}

final class MarketBoardCoordinator: CoordinatorType, MarketBoardCoordinatorType {
    private unowned let window: UIWindow
    private weak var navigation: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let httpClient = HTTPClient(isAuthorizationRequired: false)
        let binanceRequestApi = BinanceApi(httpClient: httpClient)
        let binanceSocketsApi = BinanceSocketApi()
        let binanceService = BinanceService(binanceRequestApi: binanceRequestApi, binanceSocketApi: binanceSocketsApi)
        let presenter = MarketBoardPresenter(coordinator: self)
        let interactor = MarketBoardInteractor(presenter: presenter, binanceWebSocketService: binanceService)
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
    
    func displayAuthAsRoot() {
        let coordinator = AuthCoordinator(window: window)
        coordinator.start()
    }
    
    func end() {
        window.rootViewController = nil
    }
}
