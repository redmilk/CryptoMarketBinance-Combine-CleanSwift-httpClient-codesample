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

final class MarketBoardViewController: UIViewController, ViewControllerType {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()

    var bag = Set<AnyCancellable>()
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
    
    private func configureView() {
        let debugScene = UIBarButtonItem(title: "Debug", style: .plain, target: nil, action: nil)
        debugScene.publisher()
            .sink(receiveValue: { [unowned self] sender in
                outputToInteractor.send(.openDebug)
        })
        .store(in: &bag)
        navigationItem.rightBarButtonItem  = debugScene
    }
}

// MARK: - Internal

private extension MarketBoardViewController {
    
    /// VC OUTPUT
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        outputToInteractor.send(.streamStart)
    }
    
    /// VC INPUT
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        inputFromPresenter
            .sink(receiveValue: { [unowned self] state in
            switch state {
            case .newData(let sections):
                dataManager.update(withSections: sections)
            }
        })
        .store(in: &bag)
    }
}
