//
//  Configurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine
import UIKit.UIViewController

struct AuthConfigurator: ModuleLayersBindable {
    typealias ViewController = AuthViewController
    typealias Interactor = AuthInteractor
    typealias Presenter = AuthPresenter
}
