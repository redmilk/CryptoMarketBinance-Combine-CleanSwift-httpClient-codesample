//
//  Configurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import UIKit.UIViewController

final class AuthConfigurator: ModuleLayersBindable {
    
    var interactor: AuthInteractor
    var presenter: AuthPresenter
    var controller: AuthViewController
    
    required init(interactor: AuthInteractor,
                  presenter: AuthPresenter,
                  controller: AuthViewController) {
        self.interactor = interactor
        self.presenter = presenter
        self.controller = controller
    }
}
