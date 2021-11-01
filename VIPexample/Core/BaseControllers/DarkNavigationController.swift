//
//  DarkNavigationController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 31.10.2021.
//

import UIKit.UINavigationController

final class DarkNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBarsOnSwipe = true
        navigationBar.barTintColor = .black
    }
}
