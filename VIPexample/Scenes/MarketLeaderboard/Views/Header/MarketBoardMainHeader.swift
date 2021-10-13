//
//  MarketBoardMainHeader.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit

final class MarketBoardMainHeader: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var coinAmountImage: UIImageView!
    @IBOutlet private weak var coinAmountLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var noRewardLabel: UILabel! /// whole size label
    @IBOutlet private weak var rewardInfoStackView: UIStackView!
    
    func configure(withBracketTitle title: String, coinsPrize: Int) {
        titleLabel.text = title.uppercased()
        coinAmountLabel.text = coinsPrize.description
        rewardInfoStackView.isHidden = coinsPrize <= 0
        coinAmountLabel.isHidden = coinsPrize <= 0
        backgroundImageView.image = UIImage(named: coinsPrize > 0 ? "rewardBar" : "rewardBarBottom")!
        noRewardLabel.isHidden = coinsPrize > 0
    }
}
