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

    func update(with player: Player, order: Int) {
        numberLabel.text = "\(order)"
        var nameText = "\(player.name)"
        if let jerseyNumber = player.jerseyNumber {
            nameText += "(\(jerseyNumber))"
        }
        nameLabel.text = nameText
        upButton.isHidden = order == 1
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        upButtonPressed()
    }
    
}
