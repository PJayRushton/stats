//
//  PlayerStatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class PlayerStatCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func update(with stat: Stat) {
        titleLabel.text = stat.displayName
        numberLabel.text = stat.value.displayString
    }
    
}
