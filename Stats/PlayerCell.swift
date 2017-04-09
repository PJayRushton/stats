//
//  PlayerCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class PlayerCell: UICollectionViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    
    var upButtonPressed: (() -> Void) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        insetView.layer.applyShadow()
    }
    
    func update(with player: Player, order: Int) {
        numberLabel.text = "\(order + 1))"
        
        if player.isSub {
            numberLabel.text = "S"
        }
        var nameText = player.name
        if let jerseyNumber = player.jerseyNumber, !jerseyNumber.isEmpty {
            nameText += " (\(jerseyNumber))"
        }
        nameLabel.text = nameText
        upButton.isHidden = order == 0 || player.isSub
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        upButtonPressed()
    }
    
}
