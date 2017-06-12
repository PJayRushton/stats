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
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var switchTeamButton: UIButton!
    
    var settingsPressed: (() -> Void) = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    var seasonPressed: (() -> Void) = { }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        settingsPressed()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        editPressed()
    }
    
    @IBAction func switchTeamButtonPressed(_ sender: UIButton) {
        switchTeamPressed()
    }
    
    @IBAction func teamButtonPressed(_ sender: Any) {
        seasonPressed()
    }
    
    func update(with team: Team, season: Season?, canEdit: Bool) {
        imageView.kf.setImage(with: team.imageURL, placeholder: #imageLiteral(resourceName: "stock2"))
        nameButton.setTitle(team.name, for: .normal)
        let seasonText = season?.name ?? "--"
        seasonButton.setTitle(seasonText + " 🔽", for: .normal)
        nameButton.isEnabled = canEdit
        seasonButton.isEnabled = canEdit
        editButton.isHidden = !canEdit
    }
    
}
