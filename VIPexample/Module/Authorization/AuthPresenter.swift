//
//  Presenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine
import Foundation

final class AuthPresenter: InputOutputable {
    typealias Failure = Never
  
    private unowned let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    private let _output = PassthroughSubject<AuthViewController.State, Never>()
    
    let input = PassthroughSubject<AuthInteractor.Response, Never>()
    var output: AnyPublisher<AuthViewController.State, Never> {
        _output.eraseToAnyPublisher()
    }

    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
        input.eraseToAnyPublisher()
            .sink { [weak self] interactorResponse in
                switch interactorResponse {
                /// sign in network request result
                case .signInRequestResult(let result):
                    switch result {
                    case .success(let username): self?._output.send(.signinResult(nickname: username))
                    case .failure(let error): self?._output.send(.signinResultFailure(errorMessage: error.localizedDescription))
                    }
                /// user login credentials validation result
                case .validatationResult(let result):
                    let message = result ? "Credentials is valid" : "Invalid credentials"
                    self?._output.send(.validationResult(result: result, message: message))
                case .showContent:
                    (coordinator as! AuthCoordinatorType).showContent()
                }
            }
        .store(in: &self.bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
