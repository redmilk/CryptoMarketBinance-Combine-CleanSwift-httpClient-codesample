//
//  Coordinator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import UIKit.UINavigationController
import Combine

protocol AuthCoordinatorType {
    func showContent()
}

final class AuthCoordinator: CoordinatorType, AuthCoordinatorType {
    private let window: UIWindow
    private unowned var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let presenter = AuthPresenter(coordinator: self)
        let interactor = AuthInteractor(presenter: presenter)
        let controller = AuthViewController(interactor: interactor)
        let configurator = AuthConfigurator()
        let bag = configurator.bindModuleLayers(controller: controller, interactor: interactor, presenter: presenter)
        controller.setupWithDisposableBag(bag)
        navigationController = DarkNavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showContent() {
        end()
        let coordinator = MarketBoardCoordinator(window: window)
        coordinator.start()
    }
    
    func end() {
        window.rootViewController = nil
    }
}
