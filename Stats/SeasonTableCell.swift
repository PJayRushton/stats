//
//  SeasonTableCell.swift
//  Stats
//
//  Created by Parker Rushton on 5/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AIFlatSwitch

class SeasonTableCell: UITableViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isCurrentSwitch: AIFlatSwitch!
    
    func update(with season: Season, isCurrent: Bool) {
        nameLabel.text = season.name
        isCurrentSwitch.isSelected = isCurrent
    }

}
