//
//  SceneInteractable.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import Combine

protocol SceneInteractable {
    associatedtype ViewControllerAction
    associatedtype PresenterResponse
    
    var inputFromController: PassthroughSubject<ViewControllerAction, Never> { get }
    var outputToPresenter: PassthroughSubject<PresenterResponse, Never> { get }
}
