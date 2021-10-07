//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine

protocol ViewInputableOutputable: AnyObject {
    associatedtype ViewControllerState
    associatedtype ViewControllerAction
    
    var inputFromPresenter: PassthroughSubject<ViewControllerState, Never> { get }
    var outputToInteractor: PassthroughSubject<ViewControllerAction, Never> { get }
    
    func storeSubscriptions(_ subscriptions: Set<AnyCancellable>)
}
