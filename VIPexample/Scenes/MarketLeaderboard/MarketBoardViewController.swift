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
        case newData(MarketBoardSectionModel)
    }
    enum Action {
        case streamStart
    }
}

// MARK: - MarketBoardViewController

final class MarketBoardViewController: UIViewController, ViewControllerType {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()

    private var bag: Set<AnyCancellable>!
    private lazy var dataManager = MarketBoardDisplayManager<MarketBoardSectionModel, Never>(collectionView: collectionView)

    init() {
        super.init(nibName: String(describing: MarketBoardViewController.self), bundle: nil)
        
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

private extension MarketBoardViewController {
    
    /// VC OUTPUT
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        outputToInteractor.send(.streamStart)
        
    }
    
    /// VC INPUT
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        inputFromPresenter.sink(receiveValue: { state in
            switch state {
            case .newData(let sections):
                break
            }
        })
    }
}
