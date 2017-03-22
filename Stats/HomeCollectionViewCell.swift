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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(with menuItem: HomeMenuItem ) {
        colorView.backgroundColor = menuItem.backgroundColor
        imageView.image = menuItem.image
        titleLabel.text = menuItem.title
    }
    
}
