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
    private var navigationController: UINavigationController!
    private var configurator: AuthConfigurator!
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log("AuthCoordinator", type: .lifecycle)
    }
    
    func start() {
        var bag = Set<AnyCancellable>()
        let controller = AuthViewController()
        let interactor = AuthInteractor()
        let presenter = AuthPresenter(coordinator: self)
        configurator = AuthConfigurator(
            interactor: interactor,
            presenter: presenter,
            controller: controller
        )
        configurator?.bindModuleLayers(controller: controller, bag: &bag)

        navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showContent() {
        end()
        let coordinator = ContentCoordinator(window: window)
        coordinator.start()
    }
    
    func end() {
        /// nil the configurator to avoid memory leak
        configurator = nil
        window.rootViewController = nil
    }
}
