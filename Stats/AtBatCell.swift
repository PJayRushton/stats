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
    @IBOutlet weak var pencilImageView: UIImageView!
    
    func update(with atBat: AtBat, order: Int, canEdit: Bool) {
        numberLabel.text = "\(order)."
        atBatImageView.image = atBat.resultCode.selectedImage
        atBatImageView.tintColor = atBat.resultCode.tintColor
        if atBat.rbis > 0 {
            let rbisString = atBat.rbis == 1 ? "RBI" : "RBIs"
            rbisLabel.text = "\(atBat.rbis.emojiString) \(rbisString)"
        } else {
            rbisLabel.text = nil
        }
        pencilImageView.isHidden = !canEdit
    }
    
}
