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

    @IBOutlet weak var isSelectedSwitch: AIFlatSwitch!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subImageView: UIImageView!
    
    var isTexting: Bool = false {
        didSet {
            isSelectedSwitch.isHidden = !isTexting
        }
    }
    
    private var isActive: Bool = false {
        didSet {
            guard isActive != oldValue else { return }
            isSelectedSwitch.setSelected(isActive, animated: true)
        }
    }
    
    
    func update(with player: Player, index: IndexPath, isActive: Bool) {
        backgroundColor = player.gender.color
        self.isActive = isActive
        orderLabel.text = index.section == RosterViewController.RosterSection.ordered.rawValue ? "\(index.row + 1))" : nil
        orderLabel.isHidden = index.section != 0 || isTexting
        subImageView.isHidden = true
        
        var nameText = player.displayName
        if let jerseyString = player.jerseyNumber {
            nameText += " - \(jerseyString)"
        }
        if let phone = player.phone, !phone.isEmpty {
            nameText += " 📱"
        }
        nameLabel.text = nameText
    }
    
}
