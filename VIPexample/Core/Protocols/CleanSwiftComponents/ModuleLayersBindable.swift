//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import UIKit.UIViewController
import Combine

protocol ModuleLayersBindable {
    associatedtype ViewController: InputOutputable
    associatedtype Interactor: InputOutputable
    associatedtype Presenter: InputOutputable
    
    func bindModuleLayers(
        controller: ViewController,
        interactor: Interactor,
        presenter: Presenter
    ) -> Set<AnyCancellable>
}

extension ModuleLayersBindable where
    ViewController.Output == Interactor.Input,
    Interactor.Output == Presenter.Input,
    Presenter.Output == ViewController.Input {
    
    func bindModuleLayers(
        controller: ViewController,
        interactor: Interactor,
        presenter: Presenter
    ) -> Set<AnyCancellable> {
        var bag = Set<AnyCancellable>()
        controller.output
            .sink(receiveValue: { [weak interactor] action in
                interactor?.input.send(action)
            })
            .store(in: &bag)
        interactor.output
            .sink(receiveValue: { [weak presenter] interactorResponse in
                presenter?.input.send(interactorResponse)
            })
            .store(in: &bag)
        presenter.output
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak controller] presenterResponse in
                controller?.input.send(presenterResponse)
            })
            .store(in: &bag)
        return bag
    }
}
