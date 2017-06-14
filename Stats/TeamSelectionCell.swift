//
//  TeamSelectionCell.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class TeamSelectionCell: UITableViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    func update(with team: Team, isSelected: Bool = false, fontSize: CGFloat = 30) {
        guard let teamURL = team.imageURL else { return }
        backgroundImageView.kf.setImage(with: teamURL)
        titleLabel.textColor = .white
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        titleLabel.text = team.name
        titleLabel.font = FontType.lemonMilk.font(withSize: fontSize)
        accessoryImageView.image = isSelected ? #imageLiteral(resourceName: "check") : nil
        accessoryImageView.tintColor = .mainAppColor
    }
    
}
