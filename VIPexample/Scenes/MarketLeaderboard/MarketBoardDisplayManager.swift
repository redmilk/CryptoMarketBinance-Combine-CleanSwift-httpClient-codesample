//
//  MarketBoardDisplayManager.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import Combine
import UIKit

final class MarketBoardDisplayManager<Input: MarketBoardSectionModel, Failure: Error> {
    
    typealias DataSource = UICollectionViewDiffableDataSource<MarketBoardSectionModel, MarketBoardItemModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MarketBoardSectionModel, MarketBoardItemModel>
    
    private unowned let collectionView: UICollectionView
    private var dataSource: DataSource!
    private var subscription: Subscription?
    private var completed = false
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    private func update(withSections sections: [MarketBoardSectionModel]) {
        collectionView.register(cellClassName: MarketBoardMainCell.self)
        collectionView.registerHeaderNib(MarketBoardMainHeader.self)
        dataSource = buildDataSource()
        layoutCollection()
        applySnapshot(sections: sections)
    }
}

// MARK: - Behave as a Subscriber
extension MarketBoardDisplayManager: Subscriber, Cancellable {
    func receive(subscription: Subscription) {
        if self.subscription == nil && completed == false {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
    }

    func receive(_ input: [MarketBoardSectionModel]) -> Subscribers.Demand {
        update(withSections: input)
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        switch completion {
        case .failure(_): break
        case .finished: break
        }
        subscription?.cancel()
        subscription = nil
        completed = true
    }

    func cancel() {
        subscription?.cancel()
        subscription = nil
        completed = true
    }
}

// MARK: - Internal

private extension MarketBoardDisplayManager {
    
    func applySnapshot(sections: [MarketBoardSectionModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.users, toSection: $0) }
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
                guard let self = self else { return }
                //self.collectionView.scrollToItem(at: rewardInfo.position, at: .centeredVertically, animated: false)
            })
        }
    }
    
    func buildDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [unowned self] (collectionView, indexPath, user) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: MarketBoardMainCell.self),
                    for: indexPath) as! MarketBoardMainCell
                
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: MarketBoardMainHeader.self),
                for: indexPath) as? MarketBoardMainHeader
            view?.configure(withBracketTitle: section.title, coinsPrize: Int(section.rewardAmount)!)
            return view
        }
        return dataSource
    }
    
    func layoutCollection() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 0
            /// section header
            let headerFooterSize = NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .absolute(37)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
              layoutSize: headerFooterSize,
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
        collectionView.collectionViewLayout = layout
    }
}
