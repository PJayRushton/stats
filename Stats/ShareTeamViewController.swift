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
    
    @IBOutlet weak var becomeLabel: UILabel!
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
        let fanOrManagerString = ownershipType == .fan ? "fan" : "st@ keeper"
        becomeLabel.text = "Become a \(fanOrManagerString) of:"
        nameLabel.text = team.name
        let shareCode = team.shareCodeString(ownershipType: ownershipType)
        let qrCode = QRCode(shareCode)
        qrImageView.image = qrCode?.image

        let attributedString = NSMutableAttributedString(string: shareCode)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(16), range: NSRange(location: 0, length: shareCode.characters.count - 1))
        shareLabel.attributedText = attributedString
    }
    
}
