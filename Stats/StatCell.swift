//
//  StatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class StatCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func update(with stat: Stat, place: Place?) {
        var name = stat.displayName
        if let place = place {
            name += place.emoji
        }
        titleLabel.text = name
        numberLabel.text = stat.displayString
    }
    
}
