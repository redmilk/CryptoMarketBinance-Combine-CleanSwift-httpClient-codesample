//
//  Interactor.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Foundation
import Combine

final class AuthInteractor: InputOutputable {
    typealias Failure = Never
    
    enum Response {
        case validatationResult(Bool)
        case signInRequestResult(Swift.Result<String, Error>)
        case removeRoot
        case showContent
    }
    
    private let _output = PassthroughSubject<Response, Never>()
    private var bag = Set<AnyCancellable>()
    private let presenter: AuthPresenter
    
    let input = PassthroughSubject<AuthViewController.Action, Never>()
    var output: AnyPublisher<Response, Never> {
        _output.eraseToAnyPublisher()
    }
    
    init(presenter: AuthPresenter) {
        self.presenter = presenter
        input.eraseToAnyPublisher()
            .sink { [weak self] action in
            switch action {
            case .loginPressed:
                self?._output.send(.showContent)
            case .validateCredentials(let username, let password):
                let result = self?.validateCredentials(username: username, password: password)
                self?._output.send(.validatationResult(result ?? false))
            case .removeRoot:
                self?._output.send(.removeRoot)
            }
        }
        .store(in: &self.bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    private func validateCredentials(username: String, password: String) -> Bool {
        username.count > 3 && password.count > 3
    }
    
    private func performLogin() -> Swift.Result<String, Error> {
        sleep(3)
        return .success("Username 123")
    }
}
