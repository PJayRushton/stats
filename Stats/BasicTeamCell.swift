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
    
    func update(withTitle title: String, detail: String? = nil, accessory: UITableViewCellAccessoryType = .none, image: UIImage? = nil, fontSize: CGFloat = 16) {
        titleLabel.text = title
        titleLabel.font = FontType.lemonMilk.font(withSize: fontSize)
        detailLabel.text = detail
        detailLabel.font = FontType.lemonMilk.font(withSize: fontSize * 0.7)
        accessoryType = accessory
        accessoryImageView.image = image
        accessoryImageView.tintColor = .mainAppColor
    }
    
    func update(with team: Team, isSelected: Bool = false, accessory: UITableViewCellAccessoryType = .none, fontSize: CGFloat = 16) {
        titleLabel.text = team.name
        titleLabel.font = FontType.lemonMilk.font(withSize: fontSize)
        detailLabel.text = nil
        detailLabel.font = FontType.lemonMilk.font(withSize: fontSize * 0.7)
        accessoryType = .disclosureIndicator
        accessoryType = accessory
        accessoryImageView.image = isSelected ? checkImage : nil
        accessoryImageView.tintColor = .mainAppColor
    }
    
}
