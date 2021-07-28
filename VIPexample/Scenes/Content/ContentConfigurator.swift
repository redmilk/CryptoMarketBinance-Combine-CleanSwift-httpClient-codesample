//
//  ContentConfigurator.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import UIKit.UIViewController

final class ContentConfigurator: ModuleLayersBindable {
    var interactor: ContentInteractor
    var presenter: ContentPresenter
    var controller: ContentViewController
    
    required init(interactor: ContentInteractor,
                  presenter: ContentPresenter,
                  controller: ContentViewController) {
        self.interactor = interactor
        self.presenter = presenter
        self.controller = controller
    }
}
