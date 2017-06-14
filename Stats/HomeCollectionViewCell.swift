//
//  HomeCollectionViewCell.swift
//  St@s
//
//  Created by Parker Rushton on 2/2/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        leftImageView.tintColor = .white
    }
    
    func update(with menuItem: HomeMenuItem) {
        colorView.backgroundColor = menuItem.backgroundColor
        leftImageView.image = menuItem.image
        titleLabel.text = menuItem.title
    }
    
}
