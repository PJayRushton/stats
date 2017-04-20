//
//  AtBatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/19/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class AtBatCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var atBatImageView: UIImageView!
    @IBOutlet weak var rbisLabel: UILabel!
    
    func update(with atBat: AtBat) {
        numberLabel.text = "\(atBat.order)"
//        atBatImageView = atBat.image
        rbisLabel.text = "\(atBat.rbis) RBIs"
    }
    
}
