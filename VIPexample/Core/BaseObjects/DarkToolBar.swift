//
//  DarkToolBar.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 01.11.2021.
//

import UIKit.UIToolbar

final class DarkToolBar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        backgroundColor = .black
        barTintColor = .black
    }
}
