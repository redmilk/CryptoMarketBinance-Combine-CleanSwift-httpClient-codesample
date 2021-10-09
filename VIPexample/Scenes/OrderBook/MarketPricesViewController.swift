//
//  
//  MarketPricesViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//
//

import UIKit
import Combine

// MARK: - ViewController State and Actions types

extension MarketPricesViewController {
    enum State {
        case updateMainText(String)
        case updateSocketStatus(String)
        case showError(Error)
    }
    enum Action {
        case configureSockets([String])
        case connect
        case disconnect
        case addStream([String])
        case removeStream([String])
        case reconnect
    }
}

// MARK: - MarketPricesViewController

final class MarketPricesViewController: UIViewController, ViewControllerType {
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var updateStreamTextField: UITextField!
    
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var newStreamButton: UIButton!
    @IBOutlet weak var removeStreamButton: UIButton!
    @IBOutlet weak var reconnectButton: UIButton!
    
    // MARK: - View Input-Output implementation
    
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()

    private var bag: Set<AnyCancellable>!
    
    init() {
        super.init(nibName: String(describing: MarketPricesViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - Internal

private extension MarketPricesViewController {
    
    /// ViewController output
    
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        let configure = configureButton.publisher(for: .touchUpInside).map { _ in Action.configureSockets(["!ticker@arr"]) }
        let connect = connectButton.publisher(for: .touchUpInside).map { _ in Action.connect }
        let disconnect = disconnectButton.publisher(for: .touchUpInside).map { _ in Action.disconnect }
        let reconnect = reconnectButton.publisher(for: .touchUpInside).map { _ in Action.reconnect }
        let textFieldValues = updateStreamTextField.publisher(for: .editingDidEnd)
            .compactMap { tf in tf.text }
            .map { $0.components(separatedBy: [" "]) }
        let newStreamAdd = newStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .filter { !$0.1.isEmpty }
            .map { Action.addStream($0.1) }
        let removeStream = removeStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .filter { !$0.1.isEmpty }
            .map { Action.removeStream($0.1) }
        
        Publishers.Merge6(configure, connect, disconnect, reconnect, newStreamAdd, removeStream)
            .sink(receiveValue: { [weak self] in self?.outputToInteractor.send($0) })
            .store(in: &bag)
    }
    
    /// ViewController input
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        inputFromPresenter.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .updateMainText(let text):
                    self?.mainTextView.text = text
                    Logger.log(text, type: .sockets)
                case .updateSocketStatus(let socketStatus):
                    self?.debugTextView.text = socketStatus
                    Logger.log(socketStatus)
                case .showError(let error):
                    Logger.log(error)
                    self?.debugTextView.text = error.localizedDescription
                }
            })
            .store(in: &bag)
    }
}
