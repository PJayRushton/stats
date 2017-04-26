//
//  TrophyHeaderCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class TrophyHeaderCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func update(with trophy: Trophy) {
        colorView.backgroundColor = trophy.backgroundColor
        titleLabel.text = trophy.displayName
        subtitleLabel.text = trophy.subtitle
    }
    
}
