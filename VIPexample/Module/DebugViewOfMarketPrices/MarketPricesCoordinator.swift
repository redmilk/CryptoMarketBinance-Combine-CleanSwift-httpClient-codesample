//
//  ___HEADERFILE___
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol MarketPricesCoordinatorType {
    func openMarvelScene()
}

final class MarketPricesCoordinator: CoordinatorType, MarketPricesCoordinatorType {
    private unowned let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let httpClient = HTTPClient(isAuthorizationRequired: false)
        let binanceRequestApi = BinanceApi(httpClient: httpClient)
        let binanceSocketsApi = BinanceSocketApi()
        let binanceService = BinanceService(binanceRequestApi: binanceRequestApi, binanceSocketApi: binanceSocketsApi)
        let presenter = MarketPricesPresenter(coordinator: self)
        let interactor = MarketPricesInteractor(presenter: presenter, binanceWebSocketService: binanceService)
        let controller = MarketPricesViewController(interactor: interactor)
        let configurator = MarketPricesConfigurator()
        let bag = configurator.bindModuleLayers(controller: controller, interactor: interactor, presenter: presenter)
        controller.setupWithDisposableBag(bag)
        navigation.pushViewController(controller, animated: true)
    }
    
    func openMarvelScene() {
//        end()
//        let coordinator = ContentCoordinator(navigation: navigationController)
//        coordinator.start()
    }
    
    func end() {
        //window.rootViewController = nil
    }
}
