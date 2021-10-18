//
//  Configurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine
import UIKit.UIViewController

final class AuthConfigurator: ModuleLayersBinderType {
    let controller: AuthViewController
    let interactor: AuthInteractor
    let presenter: AuthPresenter
    
    init(controller: AuthViewController, interactor: AuthInteractor, presenter: AuthPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
        var bag = Set<AnyCancellable>() // not used
        self.bindModuleLayers(controller: controller, bag: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
