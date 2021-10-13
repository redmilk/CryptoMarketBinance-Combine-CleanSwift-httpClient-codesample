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
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        inputFromController.map { [unowned self] action in
            switch action {
            case .loginPressed:
                return .showContent
            case .validateCredentials(let username, let password):
                let result = validateCredentials(username: username, password: password)
                return .validatationResult(result)
            case .removeRoot:
                return .removeRoot
            }
        }
        .subscribe(outputToPresenter)
        .store(in: &bag)
    }
    
    private func validateCredentials(username: String, password: String) -> Bool {
        return username.count > 3 && password.count > 3
    }
    
    private func performLogin() -> Swift.Result<String, Error> {
        sleep(3)
        return .success("Username 123")
    }
}
