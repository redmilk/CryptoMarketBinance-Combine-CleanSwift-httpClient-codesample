//
//  ContentCoordinator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import UIKit.UIViewController
import Combine

final class ContentCoordinator: CoordinatorType {
    
    private var window: UIWindow
    private var configurator: ContentConfigurator!

    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log("ContentCoordinator", type: .lifecycle)
    }
    
    func start() {
        var bag = Set<AnyCancellable>()
        let controller = ContentViewController()
        let interactor = ContentInteractor()
        let presenter = ContentPresenter(coordinator: self)
        configurator = ContentConfigurator(
            interactor: interactor,
            presenter: presenter,
            controller: controller
        )
        configurator?.bindModuleLayers(controller: controller, bag: &bag)
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.hidesBarsOnSwipe = true
        navigation.modalPresentationStyle = .fullScreen
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func end() {
        /// nil the configurator to avoid memory leak
        configurator = nil
        let authCoordinator = AuthCoordinator(window: window)
        authCoordinator.start()
    }
}
