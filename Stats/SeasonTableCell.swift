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
    
    private var isCurrent = false {
        didSet {
            guard isCurrent != oldValue else { return }
            isCurrentSwitch.setSelected(isCurrent, animated: true)
        }
    }
    
    func update(with season: Season, isCurrent: Bool) {
        nameLabel.text = season.name
        self.isCurrent = isCurrent
    }

}
