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

final class AuthCoordinator: Coordinatable, AuthCoordinatorType {
    private let window: UIWindow
    private var navigationController: UINavigationController!
    private var configurator: AuthConfigurator!
    private var subscriptions = Set<AnyCancellable>()
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log("AuthCoordinator", type: .lifecycle)
    }
    
    func start() {
        let controller = AuthViewController()
        let interactor = AuthInteractor()
        let presenter = AuthPresenter(coordinator: self)
        configurator = AuthConfigurator(
            interactor: interactor,
            presenter: presenter,
            controller: controller
        )
        var subscriptions = Set<AnyCancellable>()
        configurator.bindModuleLayers(controller: controller, subscriptions: &subscriptions)

        navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showContent() {
        let coordinator = ContentCoordinator(window: window)
        coordinator.start()
        coordinator.showAuthPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.start()
            })
            .store(in: &subscriptions)
    }
    
    func end() {
        window.rootViewController = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.start()
        }
    }
}
