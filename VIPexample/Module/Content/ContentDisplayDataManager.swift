//
//  ContentDisplayDataManager.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 25.10.2021.
//

import Combine
import UIKit

final class ContentDisplayDataManager: NSObject, UICollectionViewDelegate {
    typealias Failure = Never
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MurvelResult>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MurvelResult>

    enum Input {
        case newCollectionData(murvel: MurvelResult, shouldAnimate: Bool)
    }
    enum Output {
        case willDisplayCellAtIndex(index: Int, total: Int)
    }
    
    enum Section {
        case main
    }

    let input = PassthroughSubject<Input, Never>()
    var output: AnyPublisher<Output, Never> { _output.eraseToAnyPublisher() }
    
    private unowned let collectionView: UICollectionView
    private var dataSource: DataSource!
    private let _output = PassthroughSubject<Output, Never>()
    private var bag = Set<AnyCancellable>()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        input.sink(receiveValue: { [weak self] input in
            guard case .newCollectionData(
                    let marvelResult,
                    let shouldAnimate) = input else { return }
            self?.applySnapshot(murvel: marvelResult, shouldAnimate: shouldAnimate)
        })
        .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    
    func configureCollection() {
        collectionView.delegate = self
        collectionView.register(cellClassName: ContentCollectionCell.self)
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource = makeDataSource()
        let runLoopMode = CFRunLoopMode.defaultMode.rawValue
        CFRunLoopPerformBlock(CFRunLoopGetMain(), runLoopMode) { [unowned(unsafe) self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        CFRunLoopWakeUp(CFRunLoopGetMain())
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath
    ) {
        let response = Output.willDisplayCellAtIndex(index: indexPath.row, total: collectionView.numberOfItems(inSection: 0))
        _output.send(response)
    }
}

// MARK: - Internal

private extension ContentDisplayDataManager {
    
    func applySnapshot(murvel: MurvelResult, shouldAnimate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([murvel])
        let runLoopMode = CFRunLoopMode.commonModes.rawValue
        CFRunLoopPerformBlock(CFRunLoopGetMain(), runLoopMode) { [weak dataSource] in
            dataSource?.apply(snapshot, animatingDifferences: shouldAnimate)
        }
        CFRunLoopWakeUp(CFRunLoopGetMain())
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, charecter) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ContentCollectionCell.self),
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
