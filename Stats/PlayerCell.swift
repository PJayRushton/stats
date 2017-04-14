//
//  PlayerCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var upButtonPressed: (() -> Void) = {}
    var downButtonPressed: (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        insetView.layer.applyShadow()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        insetView.backgroundColor = highlighted ? .gray100 : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        insetView.backgroundColor = selected ? .gray100 : .white
    }
    
    func update(with player: Player, order: Int, isLast: Bool = false) {
        numberLabel.text = "\(order + 1))"
  
        var nameText = player.name
        if player.isSub {
            nameText += " (S)"
        } else if let jerseyNumber = player.jerseyNumber, !jerseyNumber.isEmpty {
            nameText += " (\(jerseyNumber))"
        }
        nameLabel.text = nameText
        upButton.isHidden = order == 0
        downButton.isHidden = isLast
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        upButtonPressed()
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        downButtonPressed()
    }

}
