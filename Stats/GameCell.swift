//
//  GameCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/17/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func update(with game: Game, order: Int?) {
        let homeAwayPrefix = game.isHome ? "vs." : "@"
        opponentLabel.text = "\(homeAwayPrefix) \(game.opponent)"
        gameLabel.text = order == nil ? nil : "Game \(order! + 1)"
        dateLabel.text = game.date.proximityDateTimeString
        statusLabel.text = game.status
        scoreLabel.text = "(\(game.scoreString))"
    }
    
}
