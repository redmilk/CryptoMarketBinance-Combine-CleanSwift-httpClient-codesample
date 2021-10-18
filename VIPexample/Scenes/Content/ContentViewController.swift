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
        case idle
        case character(MurvelResult)
    }
    enum Action: Equatable {
        case showAuth
        case loadCharacters
        case willDisplayCellAtIndex(index: Int, total: Int)
    }
}

// MARK: - ContentViewController

enum Section {
    case main
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, MurvelResult>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MurvelResult>


final class ContentViewController: UIViewController, ViewControllerType {
    
    // MARK: - ViewInputableOutputable implementation
    
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var bag = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init() {
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
        configureCollection()
        
        inputFromPresenter.sink(receiveValue: { [unowned self] state in
            switch state {
            case .character(let char):
                applySnapshot(murvel: char)
            case .idle: break
            }
        })
        .store(in: &bag)
        
        outputToInteractor.send(.loadCharacters)
    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
    
    private func configureView() {
        let showAuth = UIBarButtonItem(title: "Auth", style: .plain, target: nil, action: nil)
        showAuth.publisher()
            .sink(receiveValue: { [unowned self] sender in
                outputToInteractor.send(.showAuth)
        })
        .store(in: &bag)
        navigationItem.rightBarButtonItem  = showAuth
    }
    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.registerCell(ContentCollectionCell.self)
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ContentViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let action = Action.willDisplayCellAtIndex(index: indexPath.row, total: collectionView.numberOfItems(inSection: 0))
        outputToInteractor.send(action)
    }
}

private extension ContentViewController {
    
    func applySnapshot(murvel: MurvelResult, animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([murvel])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, charecter) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ContentCollectionCell",
                    for: indexPath) as? ContentCollectionCell
                cell?.configure(withMarvelResult: charecter)
                return cell
            })
        return dataSource
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
