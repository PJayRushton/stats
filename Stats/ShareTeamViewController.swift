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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let code = QRCode(team.shareCode)
        qrImageView.image = code?.image
        shareLabel.text = team.shareCode
    }
    
}
