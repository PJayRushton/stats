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
    
    func update(withTrophy trophy: Trophy, winner winnerStat: Stat, firstLoser secondStat: Stat?) {
        winnerLabel.text = statString(with: winnerStat, trophy: trophy)
        secondPlaceLabel.isHidden = secondStat == nil
        guard let firstLoserStat = secondStat else { return }
        secondPlaceLabel.text = statString(with: firstLoserStat, trophy: trophy)
    }
    
    private func statString(with stat: Stat, trophy: Trophy) -> String {
        let format = NSLocalizedString("%@ (%@ %@)", comment: "Player name ({Stat Number} Stat Type) e.g Parker (0.785 BA)")
        return String.localizedStringWithFormat(format, stat.player.name, stat.displayString, trophy.statType.displayString(isSingular: stat.value == 1))
    }
    
}
