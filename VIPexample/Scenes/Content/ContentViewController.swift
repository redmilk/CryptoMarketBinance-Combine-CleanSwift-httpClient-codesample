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
        case closePressed
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var bag: Set<AnyCancellable>!
    private lazy var dataSource = makeDataSource()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        super.init(nibName: String(describing: ContentViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        Logger.log("ContentViewController", type: .lifecycle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputFromPresenter.sink(receiveValue: { [unowned self] state in
            switch state {
            case .character(let char):
                applySnapshot(murvel: char)
            case .idle: break
            }
        })
        .store(in: &bag)
        
        configureView()
        outputToInteractor.send(.loadCharacters)
    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
    
    @objc func closePressed() {
        outputToInteractor.send(.closePressed)
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
    func configureView() {
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closePressed))
        navigationItem.setRightBarButton(button, animated: false)
        collectionView.delegate = self
        collectionView.registerCell(ContentCollectionCell.self)
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
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
