//
//  AtBatState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct OutAdded: Event { }
struct OutSubtracted: Event { }

struct AtBatState: State {
    
    var currentAtBat: AtBat?
    var allAtBats = Set<AtBat>()
    var currentResult: AtBatCode?
    var outs = 0
    
    func atBats(for game: Game) -> [AtBat] {
        return allAtBats.filter { $0.gameId == game.id }
    }
    
    func atBats(for player: Player, in game: Game? = nil) -> [AtBat] {
        let playerABs = allAtBats.filter { $0.playerId == player.id }
        guard let filteringGame = game else { return playerABs }
        return playerABs.filter { $0.gameId == filteringGame.id }
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<AtBat>:
            currentAtBat = event.item
        case let event as Updated<[AtBat]>:
            allAtBats = Set(event.payload)
            if let atBat = currentAtBat, let index = event.payload.index(of: atBat) {
                currentAtBat = event.payload[index]
            }

        case let event as Selected<AtBatCode>:
            currentResult = event.item
        case _ as OutAdded:
            outs += 1
        case _ as OutSubtracted:
            outs -= 1
        default:
            break
        }
    }
    
}
