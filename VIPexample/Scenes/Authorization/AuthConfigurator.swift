//
//  Configurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import UIKit.UIViewController

struct AuthConfigurator: ModuleLayersBinderType {
    let interactor: AuthInteractor
    let presenter: AuthPresenter
    let controller: AuthViewController
}
