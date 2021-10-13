//
//  ContentConfigurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit.UIViewController

final class ContentConfigurator: ModuleLayersBinderType {
    let controller: ContentViewController
    let interactor: ContentInteractor
    let presenter: ContentPresenter
    
    init(controller: ContentViewController, interactor: ContentInteractor, presenter: ContentPresenter) {
        self.controller = controller
        self.interactor = interactor
        self.presenter = presenter
    }
}
