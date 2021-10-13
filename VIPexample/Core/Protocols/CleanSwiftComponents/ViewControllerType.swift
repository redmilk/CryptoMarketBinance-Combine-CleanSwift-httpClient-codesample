//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine

protocol ViewControllerType: class {
    associatedtype ViewControllerState
    associatedtype ViewControllerAction
    
    var inputFromPresenter: PassthroughSubject<ViewControllerState, Never> { get }
    var outputToInteractor: PassthroughSubject<ViewControllerAction, Never> { get }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>)
}
