//
//  PlayerCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class PlayerCell: UICollectionViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    
    var upButtonPressed: (() -> Void) = {}

    func update(with player: Player) {
        numberLabel.text = "\(player.order + 1))"
        if player.isSub {
            numberLabel.text = "S"
        }
        var nameText = "\(player.name)"
        if let jerseyNumber = player.jerseyNumber {
            nameText += " (\(jerseyNumber))"
        }
        nameLabel.text = nameText
        upButton.isHidden = player.order == 0 || player.isSub
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        upButtonPressed()
    }
    
}
