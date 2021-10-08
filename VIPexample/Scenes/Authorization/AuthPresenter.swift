//
//  Presenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine
import Foundation

final class AuthPresenter: ScenePresentable {
    // MARK: - ScenePresentable implementation
    let inputFromInteractor = PassthroughSubject<AuthInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<AuthViewController.State, Never>()
    
    private let coordinator: Coordinatable & AuthCoordinatorType
    private var subscriptions = Set<AnyCancellable>()
    
    init(coordinator: Coordinatable & AuthCoordinatorType) {
        self.coordinator = coordinator
        
        inputFromInteractor
            .map { interactorResponse in
                switch interactorResponse {
                /// sign in network request result
                case .signInRequestResult(let result):
                    switch result {
                    case .success(let username): return .signinResult(nickname: username)
                    case .failure(let error): return .signinResultFailure(errorMessage: error.localizedDescription)
                    }
                /// user login credentials validation result
                case .validatationResult(let result):
                    let message = result ? "Credentials is valid" : "Invalid credentials"
                    return .validationResult(result: result, message: message)
                case .showContent:
                    coordinator.showContent()
                    return .idle
                case .removeRoot:
                    coordinator.end()
                    return .idle
                }
            }
            .subscribe(outputToViewController)
            .store(in: &subscriptions)
    }
}
