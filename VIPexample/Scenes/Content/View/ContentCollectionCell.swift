//
//  ContentCollectionCell.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import UIKit

extension UICollectionView {
    func registerCell(_ cellClass: UICollectionViewCell.Type) {
        self.register(UINib(nibName: "\(cellClass)", bundle: nil),
                      forCellWithReuseIdentifier: "\(cellClass)")
    }
}

class ContentCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withMarvelResult result: MurvelResult) {
        thumbnailImageView.image = result.image
    }

}
