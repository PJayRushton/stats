//
//  GamesHeaderCell.swift
//  Stats
//
//  Created by Parker Rushton on 6/10/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct TeamRecord {
    var gamesWon: Int
    var gamesLost: Int
}


class GamesHeaderCell: UITableViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gamesWonLabel: UILabel!
    @IBOutlet weak var gamesLostLabel: UILabel!
    @IBOutlet weak var recordStack: UIStackView!
    
    func update(withTitle title: String, record: TeamRecord?) {
        backgroundColor = .secondaryAppColor
        titleLabel.text = title
        
        if let record = record {
            gamesWonLabel.text = String(record.gamesWon)
            gamesLostLabel.text = String(record.gamesLost)
        } else {
            recordStack.isHidden = true
        }
    }
    
}
