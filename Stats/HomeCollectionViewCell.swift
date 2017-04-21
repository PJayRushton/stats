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
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(with menuItem: HomeMenuItem ) {
        colorView.backgroundColor = menuItem.backgroundColor
        emojiLabel.text = menuItem.emoji
        titleLabel.text = menuItem.title
    }
    
}
