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
    @IBOutlet weak var secondPlaceLabel: UILabel!
    
    func update(withWinner winnerStat: Stat, secondPlaceState secondStat: Stat) {
        winnerLabel.text = "\(winnerStat.displayName) - \(winnerStat.displayString)"
        secondPlaceLabel.text = "\(secondStat.displayName) - (\(secondStat.displayString))"
    }
    
}
