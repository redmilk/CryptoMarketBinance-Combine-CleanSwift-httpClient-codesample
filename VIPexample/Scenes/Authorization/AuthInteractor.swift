//
//  Interactor.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import Combine

final class AuthInteractor: InteractorType {
    enum Response {
        case validatationResult(Bool)
        case signInRequestResult(Swift.Result<String, Error>)
        case removeRoot
        case showContent
    }
    
    let inputFromController = PassthroughSubject<AuthViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    var bag: Set<AnyCancellable>
    
    init(bag: Set<AnyCancellable>) {
        self.bag = bag
        inputFromController.sink { [unowned self] action in
            switch action {
            case .loginPressed:
                outputToPresenter.send(.showContent)
            case .validateCredentials(let username, let password):
                let result = validateCredentials(username: username, password: password)
                outputToPresenter.send(.validatationResult(result))
            case .removeRoot:
                outputToPresenter.send(.removeRoot)
            }
        }
        .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    private func validateCredentials(username: String, password: String) -> Bool {
        return username.count > 3 && password.count > 3
    }
    
    private func performLogin() -> Swift.Result<String, Error> {
        sleep(3)
        return .success("Username 123")
    }
}
