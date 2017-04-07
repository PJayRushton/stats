//
//  PlayerState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct PlayerState: State {
    
    var allPlayers = Set<Player>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<Player>:
            allPlayers.remove(event.payload)
            allPlayers.insert(event.payload)
        default:
            break
        }
    }
    
    func players(for team: Team) -> [Player] {
        return allPlayers.filter { $0.teamId == team.id }
    }
    
}
