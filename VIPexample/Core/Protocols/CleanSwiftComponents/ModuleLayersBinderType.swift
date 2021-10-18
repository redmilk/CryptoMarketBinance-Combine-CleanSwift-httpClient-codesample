//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import UIKit.UIViewController
import Combine

protocol ModuleLayersBinderType: class {
    associatedtype ViewController: ViewControllerType
    associatedtype Interactor: InteractorType
    associatedtype Presenter: PresenterType
    
    var controller: ViewController { get }
    var interactor: Interactor { get }
    var presenter: Presenter { get }
    //var bag: Set<AnyCancellable> { get }
    
    /// ViewController + Presenter + Interactor layers INPUT and OUTPUT binding
    /// called in coordinator `start()`
    
    func bindModuleLayers(controller: ViewController, bag: inout Set<AnyCancellable>)
}

extension ModuleLayersBinderType where
    ViewController.ViewControllerAction == Interactor.ViewControllerAction,
    Interactor.PresenterResponse == Presenter.InteractorResponse,
    Presenter.ViewControllerState == ViewController.ViewControllerState {
    
    func bindModuleLayers(controller: ViewController, bag: inout Set<AnyCancellable>) {
        /// Requests(Actions) from VC --> Interactor
        self.controller.outputToInteractor
            .sink(receiveValue: { [weak self] action in
                self?.interactor.inputFromController.send(action)
            })
            //.subscribe(interactor.inputFromController)
            .store(in: &self.controller.bag)
        /// Response from Interactor --> Presenter
        interactor.outputToPresenter
            .sink(receiveValue: { [weak self] interactorResponse in
                self?.presenter.inputFromInteractor.send(interactorResponse)
            })
            //.subscribe(presenter.inputFromInteractor)
            .store(in: &self.controller.bag)
        /// Prepared ViewData or States from Presenter --> ViewController
        presenter.outputToViewController
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] presenterResponse in
                self?.controller.inputFromPresenter.send(presenterResponse)
            })
            //.subscribe(controller.inputFromPresenter)
            .store(in: &self.controller.bag)
        /// Need only to subscribe ViewController to Presenter's Output
        /// And send Actions to Interactor's Input
        //self.controller.storeSubscriptions(&bag)
    }
}
