//
//  ContentConfigurator.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit.UIViewController

struct ContentConfigurator: ModuleLayersBindable {
    let interactor: ContentInteractor
    let presenter: ContentPresenter
    let controller: ContentViewController
}
