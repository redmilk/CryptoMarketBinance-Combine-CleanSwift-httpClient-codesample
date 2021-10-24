//
//  MarketBoardMainHeader.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit

final class MarketBoardMainHeader: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(withTitle title: String) {
        titleLabel.text = title.uppercased()
    }
}
