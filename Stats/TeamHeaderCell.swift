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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var switchTeamButton: UIButton!
    
    var settingsPressed: (() -> Void) = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        settingsPressed()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        editPressed()
    }
    
    @IBAction func switchTeamButtonPressed(_ sender: UIButton) {
        switchTeamPressed()
    }
    
    func update(with team: Team, canEdit: Bool) {
        imageView.kf.setImage(with: team.imageURL, placeholder: #imageLiteral(resourceName: "stock5"))
        nameLabel.text = team.name
        editButton.isHidden = !canEdit
    }
    
}
