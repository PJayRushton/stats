//
//  PlayerCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AIFlatSwitch

class PlayerCell: UITableViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var selectedSwitch: AIFlatSwitch!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var isLineup = false {
        didSet {
            selectedSwitch.isHidden = !isLineup
        }
    }
    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected else { return }
            selectedSwitch.setSelected(!isSelected, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedSwitch.isSelected = true
    }
    
    func update(with player: Player, index: IndexPath, isLast: Bool = false, isSelected: Bool = true) {
        backgroundColor = player.gender.color
        selectedSwitch.setSelected(isSelected, animated: false)
        numberLabel.text = index.section == 0 ? "\(index.row + 1))" : nil
        numberLabel.isHidden = !isSelected
        
        var nameText = player.name
        if player.isSub {
            nameText += " (S)"
        } else if let jerseyNumber = player.jerseyNumber, !jerseyNumber.isEmpty {
            nameText += " (\(jerseyNumber))"
        }
        nameLabel.text = nameText
    }
    
}
