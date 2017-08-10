//
//  AtBatState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct ClearAtBats: Event { }

struct AtBatState: State {
    
    var atBats = [AtBat]()
    var currentAtBat: AtBat?
    var currentResult = AtBatCode.single
    
    func atBats(for game: Game) -> [AtBat] {
        return atBats.filter { $0.gameId == game.id }
    }
    
    func atBats(for player: Player, in game: Game? = nil) -> [AtBat] {
        let playerABs = atBats.filter { $0.playerId == player.id }
        guard let filteringGame = game else { return playerABs }
        return playerABs.filter { $0.gameId == filteringGame.id }
    }
    
    func currentAtBats(for player: Player) -> [AtBat] {
        let allPlayerAtBats = atBats(for: player)
        if let currentGame = App.core.state.gameState.currentGame {
            return allPlayerAtBats.filter { $0.gameId == currentGame.id }
        } else {
            return allPlayerAtBats
        }
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamObjectAdded<AtBat>:
            atBats.append(event.object)
            
        case let event as TeamObjectChanged<AtBat>:
            guard let index = atBats.index(of: event.object) else { return }
            atBats[index] = event.object
            
            if let current = currentAtBat, current == event.object {
                currentAtBat = event.object
            }

        case let event as TeamObjectRemoved<AtBat>:
            guard let index = atBats.index(of: event.object) else { return }
            atBats.remove(at: index)
            
            if let current = currentAtBat, current == event.object {
             currentAtBat = nil
            }

        case _ as ClearAtBats:
            atBats = []
            currentAtBat = nil
            currentResult = .single
        case let event as Selected<AtBatCode>:
            currentResult = event.item ?? .single
        default:
            break
        }
    }
    
}
