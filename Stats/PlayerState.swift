//
//  PlayerState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct PlayerState: State {
    
    var allPlayersDict = [String: [Player]]()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<Player>:
            let teamId = event.payload.teamId
            guard var teamPlayers = allPlayersDict[teamId], let index = teamPlayers.index(of: event.payload) else { return }
            teamPlayers[index] = event.payload
            allPlayersDict[teamId] = teamPlayers
        case let event as Updated<[Player]>:
            guard let first = event.payload.first else { return }
            allPlayersDict[first.teamId] = event.payload
        default:
            break
        }
    }
    
    var currentPlayers: [Player]? {
        guard let currentTeam = App.core.state.teamState.currentTeam else { return nil }
        return players(for: currentTeam.id)
    }
    
    func players(for team: Team) -> [Player] {
        return players(for: team.id).sorted(by: { $0.order < $1.order })
    }
    
    func players(for teamId: String) -> [Player] {
        guard let teamPlayers = allPlayersDict[teamId] else { return [] }
        return teamPlayers.sorted(by: { $0.order < $1.order })
    }
    
}
