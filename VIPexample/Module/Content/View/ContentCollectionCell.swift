//
//  ContentCollectionCell.swift
//  VIPexample
//
//  Created by Danil Timofeyev on 10.05.2021.
//

import UIKit

final class ContentCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    func configure(withMarvelResult result: MurvelResult) {
        thumbnailImageView.image = result.image
    }
}
