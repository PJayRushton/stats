//
//  BasicCell.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func update(withTitle title: String, detail: String?, accessory: UITableViewCellAccessoryType = .none) {
        titleLabel.text = title
        detailLabel.text = detail
        accessoryType = accessory
    }
    
    func update(with team: Team) {
        titleLabel.text = team.name
    }
    
}
