//
//  TeamHeaderCell.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Kingfisher

class TeamHeaderCell: UICollectionViewCell, AutoReuseIdentifiable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seasonSwitcherArrow: UIImageView!
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var teamSwitcherButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var settingsPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    var seasonPressed: (() -> Void) = { }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        settingsPressed()
    }
    
    @IBAction func teamSwitcherButtonPressed(_ sender: UIButton) {
        switchTeamPressed()
    }
    
    @IBAction func seasonButtonPressed(_ sender: Any) {
        seasonPressed()
    }
    
    func update(with team: Team, season: Season?, canSwitch: Bool) {
        imageView.kf.setImage(with: team.imageURL, placeholder: #imageLiteral(resourceName: "stock2"))
        nameLabel.text = team.name
        teamSwitcherButton.isHidden = !canSwitch
        let seasonText = season?.name ?? "--"
        seasonButton.setTitle(seasonText + " ", for: .normal)
        seasonSwitcherArrow.tintColor = .mainAppColor
    }
    
}
