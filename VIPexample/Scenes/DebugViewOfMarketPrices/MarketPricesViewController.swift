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
        case recievedResponseModel(model: CommonSymbolTickerType?)
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
        dispatchActionsForInteractor()
        subscribePresenterOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
}

// MARK: - ViewController Input-Output and Helper methods

private extension MarketPricesViewController {
    
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
                case .recievedResponseModel(let model):
                    self?.updateWithModel(model)
                case .updateSocketStatus(let socketStatus, let shouldCleanView):
                    self?.updateWithSocketStatus(socketStatus, shouldCleanView)
                case .failure(let errorMessage, let shouldCleanView):
                    self?.handleErrorDescription(errorMessage, shouldCleanView)
                }
            })
            .store(in: &bag)
    }
    
    // MARK: - Helper methods
    
    func updateWithModel(_ model: CommonSymbolTickerType?) {
        guard let model = model else { return }
        switch model {
        case .singleSymbol(let singleSymbolModel):
            print((singleSymbolModel.symbol) + " " + (singleSymbolModel.priceChangePercent) + "%")
            mainTextView.text += "\t" + (singleSymbolModel.symbol) + " " + (singleSymbolModel.lastPriceFormatted)
        case .multipleSymbols(let multipleSymbolModel):
            print((multipleSymbolModel.data.symbol) + " " + (multipleSymbolModel.data.priceChangePercent) + "%")
            mainTextView.text += "\t" + (multipleSymbolModel.data.symbol) + " " + (multipleSymbolModel.data.lastPriceFormatted)
        }
        let range = NSMakeRange(self.mainTextView.text.count, 0)
        mainTextView.scrollRangeToVisible(range)
    }
    
    func updateWithSocketStatus(_ status: String, _ shouldCleanView: Bool) {
        debugTextView.text = status
        shouldCleanView ? mainTextView.text = nil : ()
        Logger.log(status, type: .sockets)
    }
    
    func handleErrorDescription(_ errorDescription: String, _ shouldCleanView: Bool) {
        debugTextView.text = errorDescription
        shouldCleanView ? mainTextView.text = nil : ()
    }
}
