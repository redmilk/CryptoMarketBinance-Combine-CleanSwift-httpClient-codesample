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
    //private var navigationController: UINavigationController!
    private var configurator: AuthConfigurator?
    
    init(window: UIWindow) {
        self.window = window
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func start() {
        let controller = AuthViewController()
        let interactor = AuthInteractor()
        interactor.bag = controller.bag
        let presenter = AuthPresenter(coordinator: self)
        presenter.bag = controller.bag
        controller.outputToInteractor
            .sink(receiveValue: { action in
                interactor.inputFromController.send(action)
            })
            //.subscribe(interactor.inputFromController)
            .store(in: &controller.bag)
        /// Response from Interactor --> Presenter
        interactor.outputToPresenter
            .sink(receiveValue: { interactorResponse in
                presenter.inputFromInteractor.send(interactorResponse)
            })
            //.subscribe(presenter.inputFromInteractor)
            .store(in: &controller.bag)
        /// Prepared ViewData or States from Presenter --> ViewController
        presenter.outputToViewController
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { presenterResponse in
                controller.inputFromPresenter.send(presenterResponse)
            })
            //.subscribe(controller.inputFromPresenter)
            .store(in: &controller.bag)
//        let configurator = AuthConfigurator(
//            controller: AuthViewController(),
//            interactor: AuthInteractor(),
//            presenter: AuthPresenter(coordinator: self)
//        )
        //navigationController = UINavigationController(rootViewController: configurator.controller)
        window.rootViewController = controller//configurator.controller//navigationController
        window.makeKeyAndVisible()
        //configurator = nil
    }
    
    func showContent() {
        end()
        let window = self.window
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let coordinator = AuthCoordinator(window: window)//ContentCoordinator(window: window)//MarketBoardCoordinator(window: window)//
            coordinator.start()
        })
    }
    
    func end() {
        /// nil the configurator to avoid memory leak
        configurator = nil
        window.rootViewController = nil
    }
}
