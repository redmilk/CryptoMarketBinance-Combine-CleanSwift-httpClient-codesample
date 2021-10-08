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
        case idle
        case validationResult(result: Bool, message: String)
        case signinResult(nickname: String)
        case signinResultFailure(errorMessage: String)
    }
    enum Action {
        case loginPressed
        case validateCredentials(String, String)
        case removeRoot
    }
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController, ViewControllerType {
    
    // MARK: - ViewInputableOutputable implementation
    
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var usernameTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var removeRootButton: UIButton!
    
    private var bag: Set<AnyCancellable>!
    
    init() {
        super.init(nibName: String(describing: AuthViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        Logger.log("AuthViewController", type: .lifecycle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribePresenterOutput()
        dispatchActionsForInteractor()
    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
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
        
        let removeRootAction = removeRootButton.publisher(for: .touchUpInside)
            .map { _ in  Action.removeRoot }
        
        let loginPressedAction = loginButton.publisher(for: .touchUpInside)
            .map { _ in Action.loginPressed }
        
        Publishers.Merge3(credentialsAction, removeRootAction, loginPressedAction)
            .subscribe(outputToInteractor)
            .store(in: &bag)
    }
    
    /// Presenter output handler
    func subscribePresenterOutput() {
        inputFromPresenter
            .sink(receiveValue: { [unowned self] viewModel in
                switch viewModel {
                
                case .signinResult(let nickname):
                    messageLabel.text = nickname
                    
                case .signinResultFailure(let errorMessage):
                    messageLabel.text = errorMessage
                    
                case .validationResult(let result, let validationResultMessage):
                    messageLabel.text = validationResultMessage
                    loginButton.isEnabled = result
                    
                case .idle: break
                }
            })
            .store(in: &bag)
    }
}
