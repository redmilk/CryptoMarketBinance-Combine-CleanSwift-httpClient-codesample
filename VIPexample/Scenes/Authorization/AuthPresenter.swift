//
//  Presenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine
import Foundation

final class AuthPresenter: PresenterType {
    
    let inputFromInteractor = PassthroughSubject<AuthInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<AuthViewController.State, Never>()
    
    private unowned let coordinator: CoordinatorType
    var bag: Set<AnyCancellable>
    
    init(coordinator: CoordinatorType, bag: inout Set<AnyCancellable>) {
        self.coordinator = coordinator
        self.bag = bag
        inputFromInteractor.sink { [unowned self] interactorResponse in
                switch interactorResponse {
                /// sign in network request result
                case .signInRequestResult(let result):
                    switch result {
                    case .success(let username): outputToViewController.send(.signinResult(nickname: username))
                    case .failure(let error): return outputToViewController.send(.signinResultFailure(errorMessage: error.localizedDescription))
                    }
                /// user login credentials validation result
                case .validatationResult(let result):
                    let message = result ? "Credentials is valid" : "Invalid credentials"
                    outputToViewController.send(.validationResult(result: result, message: message))
                case .showContent: break
                    //coordinator.showContent()
                case .removeRoot:
                    coordinator.end()
                }
            }
            .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
