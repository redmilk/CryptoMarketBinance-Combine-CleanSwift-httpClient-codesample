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
    
    private var navigation: UINavigationController

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let presenter = ContentPresenter(coordinator: self)
        let interactor = ContentInteractor(presenter: presenter)
        let controller = ContentViewController(interactor: interactor)
        let configurator = ContentConfigurator()
        let bag = configurator.bindModuleLayers(controller: controller, interactor: interactor, presenter: presenter)
        controller.setupWithDisposableBag(bag)
        navigation.pushViewController(controller, animated: true)
        //navigation.hidesBarsOnSwipe = true
        //navigation.modalPresentationStyle = .fullScreen
    }
    
    func end() {
        #warning("for debug")
//        let authCoordinator = AuthCoordinator(window: window)
//        authCoordinator.start()
    }
}
