//
//  GameState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct GameState: State {
    
    var currentGame: Game?
    var allGames = Set<Game>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Game>:
            currentGame = event.item
        case let event as Updated<Game>:
            allGames.remove(event.payload)
            allGames.insert(event.payload)
        default:
            break
        }
    }
    
}
