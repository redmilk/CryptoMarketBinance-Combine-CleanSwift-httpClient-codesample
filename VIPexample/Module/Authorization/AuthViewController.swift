//
//  ViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit
import Combine

// MARK: - view controller State and Actions types
extension AuthViewController {
    enum State {
        case validationResult(result: Bool, message: String)
        case signinResult(nickname: String)
        case signinResultFailure(errorMessage: String)
    }
    enum Action {
        case loginPressed
        case validateCredentials(String, String)
    }
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController, InputOutputable {
    typealias Failure = Never
        
    @IBOutlet private weak var usernameTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let interactor: AuthInteractor
    private var bag: Set<AnyCancellable>!
    private let _output = PassthroughSubject<Action, Never>()
    
    let input = PassthroughSubject<State, Never>()
    var output: AnyPublisher<Action, Never> {
        _output.eraseToAnyPublisher()
    }
    
    init(interactor: AuthInteractor) {
        self.interactor = interactor
        super.init(nibName: String(describing: AuthViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        subscribePresenterOutput()
        dispatchActionsForInteractor()
    }
    
    func setupWithDisposableBag(_ bag: Set<AnyCancellable>) {
        self.bag = bag
    }
}

// MARK: - Private

private extension AuthViewController {
    /// Sending actions into interactor input
    func dispatchActionsForInteractor() {
        let credentialsAction = Publishers.CombineLatest(
            usernameTextfield.publisher(for: .editingChanged).compactMap { $0.text },
            passwordTextfield.publisher(for: .editingChanged).compactMap { $0.text }
        )
        .map { .validateCredentials($0.0, $0.1) }
        .prepend(Action.validateCredentials("", ""))
        
        let loginPressedAction = loginButton.publisher(for: .touchUpInside)
            .map { _ in Action.loginPressed }
         
        let outputToInteractor = _output
        Publishers.Merge(credentialsAction, loginPressedAction)
            .sink(receiveValue: { [weak outputToInteractor] action in
                outputToInteractor?.send(action)
            })
            .store(in: &bag)
    }
    
    /// Presenter output handler
    func subscribePresenterOutput() {
        input.eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] viewModel in
                switch viewModel {
                case .signinResult(let nickname):
                    self?.messageLabel.text = nickname
                case .signinResultFailure(let errorMessage):
                    self?.messageLabel.text = errorMessage
                case .validationResult(let result, let validationResultMessage):
                    self?.messageLabel.text = validationResultMessage
                    self?.loginButton.isEnabled = result
                    self?.messageLabel.textColor = result ? .green : .red
                }
            })
            .store(in: &bag)
    }
}
