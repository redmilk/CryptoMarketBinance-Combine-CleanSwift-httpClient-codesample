//
//  ModelConfigurable.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import Foundation

protocol ModelConfigurable {
    associatedtype Model
    func configure(withModel model: Model)
}
