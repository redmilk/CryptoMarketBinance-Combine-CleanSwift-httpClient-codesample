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
    private unowned let window: UIWindow
    //private var navigationController: UINavigationController!
    
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
        
        window.rootViewController = controller//configurator.controller//navigationController
        window.makeKeyAndVisible()
        //navigationController = UINavigationController(rootViewController: configurator.controller)
    }
    
    func showContent() {
        end()
        let window = self.window
        let coordinator = AuthCoordinator(window: window)//ContentCoordinator(window: window)//MarketBoardCoordinator(window: window)//
        coordinator.start()
    }
    
    func end() {
        window.rootViewController = nil
        print()
        print()
        print()
    }
}
