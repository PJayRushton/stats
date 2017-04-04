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
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    fileprivate let checkImage = UIImage(named: "check")
    
    func update(withTitle title: String, detail: String? = nil, accessory: UITableViewCellAccessoryType = .none, image: UIImage? = nil) {
        titleLabel.text = title
        detailLabel.text = detail
        accessoryType = accessory
        accessoryImageView.image = image
    }
    
    func update(with team: Team, isSelected: Bool = false, accessory: UITableViewCellAccessoryType = .none) {
        titleLabel.text = team.name
        detailLabel.text = nil
        accessoryType = .disclosureIndicator
        accessoryType = accessory
        accessoryImageView.image = isSelected ? checkImage : nil
    }
    
}
