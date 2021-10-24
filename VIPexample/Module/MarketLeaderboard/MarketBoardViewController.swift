//
//  
//  MarketBoardViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//
//

import UIKit
import Combine

// MARK: - view controller State and Actions types

extension MarketBoardViewController {
    enum State {
        case newData([MarketBoardSectionModel])
    }
    enum Action {
        case streamStart
        case openDebug
    }
}

// MARK: - MarketBoardViewController

final class MarketBoardViewController: UIViewController, InputOutputable {
    typealias Failure = Never
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let input = PassthroughSubject<State, Never>()
    var output: AnyPublisher<Action, Never> { _output.eraseToAnyPublisher() }
    
    private let _output = PassthroughSubject<Action, Never>()
    private var bag = Set<AnyCancellable>()
    private lazy var dataManager = MarketBoardDisplayManager(collectionView: collectionView)

    init() {
        super.init(nibName: String(describing: MarketBoardViewController.self), bundle: nil)
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
        subscribePresenterOutput()
        dispatchActionsForInteractor()
        dataManager.configure()
    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
    
    /// VC OUTPUT
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        _output.send(.streamStart)
    }
    
    /// VC INPUT
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        input.sink(receiveValue: { [unowned self] state in
            switch state {
            case .newData(let sections):
                dataManager.update(withSections: sections)
            }
        })
        .store(in: &bag)
    }
    
    private func configureView() {
        let debugScene = UIBarButtonItem(title: "Debug", style: .plain, target: nil, action: nil)
        debugScene.publisher()
            .sink(receiveValue: { [unowned self] sender in
                _output.send(.openDebug)
        })
        .store(in: &bag)
        navigationItem.rightBarButtonItem  = debugScene
    }
}
