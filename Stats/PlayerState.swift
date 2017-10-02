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
        case let event as TeamObjectAdded<Player>:
            allPlayers.update(with: event.object)
        case let event as TeamObjectChanged<Player>:
            allPlayers.update(with: event.object)
        case let event as TeamObjectRemoved<Player>:
            allPlayers.remove(event.object)
        default:
            break
        }
    }
    
    
    // MARK: - Accessors
    
    var currentStatPlayers: [Player] {
        if let currentGame = App.core.state.statState.currentGame {
            return currentGame.lineupIds.flatMap { player(withId: $0) }
        } else {
            let currentSeasonPlayerIds = Set(App.core.state.atBatState.atBats.map { $0.playerId })
            var currentSeasonPlayers = currentSeasonPlayerIds.flatMap { player(withId: $0) }
            
            if !App.core.state.statState.includeSubs {
                currentSeasonPlayers = currentSeasonPlayers.filter { !$0.isSubForCurrentSeason }
            }
            return currentSeasonPlayers
        }
    }
    var currentStatPlayerIds: [String] {
        return currentStatPlayers.map { $0.id }
    }
    
    func players(for team: Team) -> [Player] {
        return players(for: team.id).sorted(by: { $0.order < $1.order })
    }
    
    func players(for teamId: String) -> [Player] {
        let teamPlayers = allPlayers.filter { $0.teamId == teamId }
        return teamPlayers.sorted(by: { $0.order < $1.order })
    }
    
    func currentPlayers(for teamId: String) -> [Player] {
        let teamPlayers = players(for: teamId)
        return teamPlayers.filter { $0.isInCurrentSeason }.sorted(by: { $0.order < $1.order })
    }
    
    func player(withId id: String) -> Player? {
        let state = App.core.state
        guard let currentTeam = state.teamState.currentTeam else { return nil }
        let teamPlayers = state.playerState.players(for: currentTeam)
        return teamPlayers.first(where: { $0.id == id })
    }
    
}
