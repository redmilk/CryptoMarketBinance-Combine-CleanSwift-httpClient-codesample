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
        case recievedPreparedTextData(text: String)
        case updateSocketStatus(newStatus: String, shouldCleanView: Bool)
        case failure(errorDescription: String, shouldCleanView: Bool)
    }
    enum Action {
        case configureSockets([String])
        case connect
        case disconnect
        case addStream([String])
        case removeStream([String])
        case reconnect
        case openMarvelScene
    }
}

// MARK: - MarketPricesViewController

final class MarketPricesViewController: UIViewController {
    
    @IBOutlet private weak var mainTextView: UITextView!
    @IBOutlet private weak var debugTextView: UITextView!
    @IBOutlet private weak var updateStreamTextField: UITextField!
    @IBOutlet private weak var configureButton: UIButton!
    @IBOutlet private weak var connectButton: UIButton!
    @IBOutlet private weak var disconnectButton: UIButton!
    @IBOutlet private weak var newStreamButton: UIButton!
    @IBOutlet private weak var removeStreamButton: UIButton!
    @IBOutlet private weak var reconnectButton: UIButton!
        
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()

    var bag = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: String(describing: MarketPricesViewController.self), bundle: nil)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        dispatchActionsForInteractor()
        subscribePresenterOutput()
    }
    
    private func updateWithTextData(_ text: String) {
        mainTextView.text += "\n \(text)"
        let range = NSMakeRange(self.mainTextView.text.count, 0)
        mainTextView.scrollRangeToVisible(range)
    }
    
    private func updateWithNewSocketStatus(_ socketStatus: String, _ shouldCleanView: Bool) {
        debugTextView.text = socketStatus
        shouldCleanView ? mainTextView.text = nil : ()
        Logger.log(socketStatus, type: .sockets)
    }
    
    private func updateWithErrorDescription(_ errorDescription: String, _ shouldCleanView: Bool) {
        debugTextView.text = errorDescription
        shouldCleanView ? mainTextView.text = nil : ()
        Logger.logError(nil, descriptions: errorDescription)
    }
    
    private func configureView() {
        let marvelScene = UIBarButtonItem(title: "Marvel", style: .plain, target: nil, action: nil)
        marvelScene.publisher()
            .sink(receiveValue: { [unowned self] sender in
                outputToInteractor.send(.openMarvelScene)
        })
        .store(in: &bag)
        navigationItem.rightBarButtonItem  = marvelScene
    }
}

// MARK: - Clean Swift ViewController Input-Output

extension MarketPricesViewController: ViewControllerType {
    
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        let configure = configureButton.publisher(for: .touchUpInside)
            .compactMap { [weak self] _ in self?.updateStreamTextField.text?.components(separatedBy: [" "]).filter { !$0.isEmpty } }
            .map { Action.configureSockets($0) }
        let connect = connectButton.publisher(for: .touchUpInside).map { _ in Action.connect }
        let disconnect = disconnectButton.publisher(for: .touchUpInside).map { _ in Action.disconnect }
        let reconnect = reconnectButton.publisher(for: .touchUpInside).map { _ in Action.reconnect }
        let textFieldValues = updateStreamTextField.publisher(for: .editingChanged)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .compactMap { $0.text?.components(separatedBy: [" "]).filter { !$0.isEmpty } }
        let newStreamAdd = newStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .map { Action.addStream($0.1) }
        let removeStream = removeStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .map { Action.removeStream($0.1) }
        
        Publishers.Merge6(configure, connect, disconnect, reconnect, newStreamAdd, removeStream)
            .sink(receiveValue: { [weak self] in self?.outputToInteractor.send($0) })
            .store(in: &bag)
    }
        
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        inputFromPresenter
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .recievedPreparedTextData(let preparedTextData):
                    self?.updateWithTextData(preparedTextData)
                case .updateSocketStatus(let socketStatus, let shouldCleanView):
                    self?.updateWithNewSocketStatus(socketStatus, shouldCleanView)
                case .failure(let errorMessage, let shouldCleanView):
                    self?.updateWithErrorDescription(errorMessage, shouldCleanView)
                }
            })
            .store(in: &bag)
    }
    
    /// this called from `ModuleLayersBinderType` protocol extension implicitly, no need to call
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
}
