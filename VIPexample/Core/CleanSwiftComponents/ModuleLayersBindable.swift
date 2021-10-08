//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import UIKit.UIViewController
import Combine

protocol ModuleLayersBindable {
    associatedtype Interactor: SceneInteractable
    associatedtype Presenter: ScenePresentable
    associatedtype ViewController: ViewInputableOutputable
    
    var interactor: Interactor { get }
    var presenter: Presenter { get }
    var controller: ViewController { get }
    
    init(interactor: Interactor, presenter: Presenter, controller: ViewController)
    
    // MARK: - ViewController + Presenter + Interactor layers INPUT and OUTPUT binding
    
    func bindModuleLayers(controller: ViewController, subscriptions: inout Set<AnyCancellable>)
}

extension ModuleLayersBindable where
    ViewController.ViewControllerAction == Interactor.ViewControllerAction,
    Interactor.PresenterResponse == Presenter.InteractorResponse,
    Presenter.ViewControllerState == ViewController.ViewControllerState {
    
    func bindModuleLayers(controller: ViewController, subscriptions: inout Set<AnyCancellable>) {
        controller.outputToInteractor
            .subscribe(interactor.inputFromController)
            .store(in: &subscriptions)
        
        interactor.outputToPresenter
            .subscribe(presenter.inputFromInteractor)
            .store(in: &subscriptions)
        
        presenter.outputToViewController
            .receive(on: DispatchQueue.main)
            .subscribe(controller.inputFromPresenter)
            .store(in: &subscriptions)
        
        controller.storeSubscriptions(subscriptions)
    }
}
