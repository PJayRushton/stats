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
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badgeView.layer.cornerRadius = badgeView.frame.size.height / 2
    }
    
    func update(with menuItem: HomeMenuItem, badgeCount: Int? = nil) {
        colorView.backgroundColor = .white
        colorView.layer.applyShadow()
        leftImageView.image = menuItem.image
        leftImageView.tintColor = .black
        titleLabel.text = menuItem.title
        titleLabel.textColor = .black
        
        if let badgeCount = badgeCount {
            badgeView.alpha = 1 // To hide the badge but not throw off the stackview layout
            badgeLabel.text = badgeCount == 0 ? nil : String(badgeCount)
        } else {
            badgeView.alpha = 0
        }
    }
    
}
