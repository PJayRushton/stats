//
//  StatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class StatCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    func update(with title: String) {
        textLabel.text = title
    }
    
    func update(with stat: Stat, place: Place?) {
        colorView.backgroundColor = place?.color ?? .white
        textLabel.text = stat.displayString
    }
    
}
