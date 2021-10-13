//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine

protocol InteractorType: class {
    associatedtype ViewControllerAction
    associatedtype PresenterResponse
    
    var inputFromController: PassthroughSubject<ViewControllerAction, Never> { get }
    var outputToPresenter: PassthroughSubject<PresenterResponse, Never> { get }
}
