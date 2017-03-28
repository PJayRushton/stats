//
//  PlayerState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct PlayerState: State {
    
    var currentPlayer: Player?
    var allPlayers = Set<Player>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Player>:
            currentPlayer = event.item
        case let event as Updated<Player>:
            allPlayers.insert(event.payload)
        default:
            break
        }
    }
    
}
