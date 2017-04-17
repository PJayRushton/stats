//
//  ShareTeamViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/14/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import QRCode

class ShareTeamViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    
    var ownershipType = TeamOwnershipType.fan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        shareLabel.text = ""
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    override func update(with state: AppState) {
        if let team = state.teamState.currentTeam {
            updateUI(with: team)
        }
    }
    
}

extension ShareTeamViewController {
    
    fileprivate func updateUI(with team: Team) {
        nameLabel.text = team.name
        let code = QRCode(team.qrCodeString(type: ownershipType))
        qrImageView.image = code?.image
        shareLabel.text = team.shareCode
    }
    
}
