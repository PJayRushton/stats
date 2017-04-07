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
        case let event as Updated<[Player]>:
            event.payload.forEach { player in
                allPlayers.remove(player)
                allPlayers.insert(player)
            }
        default:
            break
        }
    }
    
    func players(for team: Team) -> [Player] {
        return players(for: team.id)
    }
    
    func players(for teamId: String) -> [Player] {
        return allPlayers.filter { $0.teamId == teamId }
    }
    
}
