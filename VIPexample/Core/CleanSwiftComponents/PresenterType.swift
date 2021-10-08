//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine

protocol PresenterType {
    associatedtype InteractorResponse
    associatedtype ViewControllerState
    associatedtype Coordinator
    
    init(coordinator: Coordinator)
    
    var inputFromInteractor: PassthroughSubject<InteractorResponse, Never> { get }
    var outputToViewController: PassthroughSubject<ViewControllerState, Never> { get }
}
