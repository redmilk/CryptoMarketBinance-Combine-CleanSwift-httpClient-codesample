//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine

protocol PresenterType: class {
    associatedtype InteractorResponse
    associatedtype ViewControllerState
    associatedtype CoordinatorType
    
    init(coordinator: CoordinatorType)
    
    var inputFromInteractor: PassthroughSubject<InteractorResponse, Never> { get }
    var outputToViewController: PassthroughSubject<ViewControllerState, Never> { get }
}
