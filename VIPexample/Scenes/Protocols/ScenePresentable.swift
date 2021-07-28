//
//  Presentable.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import Combine

protocol ScenePresentable {
    associatedtype InteractorResponse
    associatedtype ViewControllerState
    associatedtype Coordinator
    
    init(coordinator: Coordinator)
    
    var inputFromInteractor: PassthroughSubject<InteractorResponse, Never> { get }
    var outputToViewController: PassthroughSubject<ViewControllerState, Never> { get }
}
