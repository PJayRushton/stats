//
//  TrophyWinnerCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class TrophyWinnerCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var honorableMentionLabel: UILabel!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    
    func update(withTrophy trophy: Trophy, winner winnerStat: Stat, firstLoser secondStat: Stat?) {
        winnerLabel.text = "\(winnerStat.player.name) - (\(winnerStat.displayString) \(trophy.statType.displayString))"
        
        if let firstLoserStat = secondStat {
            honorableMentionLabel.isHidden = false
            secondPlaceLabel.text = "\(firstLoserStat.player.name) - (\(firstLoserStat.displayString) \(trophy.statType.displayString))"
        } else {
            honorableMentionLabel.isHidden = true
        }
    }
    
}
