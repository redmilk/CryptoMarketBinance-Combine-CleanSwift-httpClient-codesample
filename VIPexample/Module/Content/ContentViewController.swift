//
//  ContentViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit
import Combine

// MARK: - view controller State and Action types

extension ContentViewController {
    enum State {
        case loading
        case character(MurvelResult)
    }
    enum Action: Equatable {
        case showAuth
        case loadCharacters
        case willDisplayCellAtIndex(index: Int, total: Int)
    }
}

// MARK: - ContentViewController

final class ContentViewController: UIViewController, InputOutputable {
    typealias Failure = Never
    
    let input = PassthroughSubject<State, Never>()
    var output: AnyPublisher<Action, Never> { _output.eraseToAnyPublisher() }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let interactor: ContentInteractor
    private var bag: Set<AnyCancellable>!
    private let _output = PassthroughSubject<Action, Never>()
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var dataManager = ContentDisplayDataManager(collectionView: collectionView)
    
    init(interactor: ContentInteractor) {
        self.interactor = interactor
        super.init(nibName: String(describing: ContentViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        dataManager.configureCollection()
        
        input.sink(receiveValue: { [unowned self] state in
            switch state {
            case .character(let char):
                dataManager.input.send(.newCollectionData(murvel: char, shouldAnimate: false))
            case .loading: break
            }
        })
        .store(in: &bag)
        
        _output.send(.loadCharacters)
    }
    
    func setupWithDisposableBag(_ bag: Set<AnyCancellable>) {
        self.bag = bag
    }
    
    private func configureView() {
        let showAuth = UIBarButtonItem(title: "Auth", style: .plain, target: nil, action: nil)
        showAuth.publisher()
            .sink(receiveValue: { [unowned self] sender in
                _output.send(.showAuth)
        })
        .store(in: &bag)
        navigationItem.rightBarButtonItem  = showAuth
    }
}
