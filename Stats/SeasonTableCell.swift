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
    @IBOutlet weak var isViewingSwitch: AIFlatSwitch!
    @IBOutlet weak var isCurrentLabel: UILabel!
    
    private var isViewing = false {
        didSet {
            guard isViewing != oldValue else { return }
            isViewingSwitch.setSelected(isViewing, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isViewingSwitch.isSelected = false
    }
    
    func update(with season: Season, isCurrent: Bool, isViewing: Bool) {
        nameLabel.text = season.name
        self.isViewing = isViewing
        isCurrentLabel.isHidden = !isCurrent
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isCurrentLabel.isHidden = true
    }
}
