//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import UIKit.UIViewController
import Combine

protocol ModuleLayersBinderType {
    associatedtype Interactor: InteractorType
    associatedtype Presenter: PresenterType
    associatedtype ViewController: ViewControllerType
    
    var interactor: Interactor { get }
    var presenter: Presenter { get }
    var controller: ViewController { get }
    
    init(interactor: Interactor, presenter: Presenter, controller: ViewController)
    
    /// ViewController + Presenter + Interactor layers INPUT and OUTPUT binding
    /// call in coordinator start()
    func bindModuleLayers(controller: ViewController, bag: inout Set<AnyCancellable>)
}

extension ModuleLayersBinderType where
    ViewController.ViewControllerAction == Interactor.ViewControllerAction,
    Interactor.PresenterResponse == Presenter.InteractorResponse,
    Presenter.ViewControllerState == ViewController.ViewControllerState {
    
    func bindModuleLayers(controller: ViewController, bag: inout Set<AnyCancellable>) {
        /// Requests(Actions) from VC --> Interactor
        controller.outputToInteractor
            .subscribe(interactor.inputFromController)
            .store(in: &bag)
        /// Response from Interactor --> Presenter
        interactor.outputToPresenter
            .subscribe(presenter.inputFromInteractor)
            .store(in: &bag)
        /// Prepared ViewData or States from Presenter --> ViewController
        presenter.outputToViewController
            .receive(on: DispatchQueue.main)
            .subscribe(controller.inputFromPresenter)
            .store(in: &bag)
        /// Need only to subscribe ViewController to Presenter's Output
        /// And send Actions to Interactor's Input
        controller.storeSubscriptions(&bag)
    }
}
