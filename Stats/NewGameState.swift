//
//  NewGameState.swift
//  Stats
//
//  Created by Parker Rushton on 4/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct LineupUpdated: Event {
    var players: [Player]
}

struct NewGameState: State {
    
    var lineup: [Player]?
    var isReadyToShow = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as LineupUpdated:
            lineup = event.players
        case let event as NewGameReadyToShow:
            isReadyToShow = event.ready
        default:
            break
        }
    }
    
}
