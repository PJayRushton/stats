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
    var playersAreLoaded = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamEntitiesUpdated<Player>:
            allPlayersDict[event.teamId] = event.entities
            playersAreLoaded = true
        default:
            break
        }
    }
    
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
    
    func players(for team: Team) -> [Player] {
        return players(for: team.id).sorted(by: { $0.order < $1.order })
    }
    
    func players(for teamId: String) -> [Player] {
        guard let teamPlayers = allPlayersDict[teamId] else { return [] }
        return teamPlayers.sorted(by: { $0.order < $1.order })
    }
    
    func currentPlayers(for teamId: String) -> [Player] {
        guard let teamPlayers = allPlayersDict[teamId] else { return [] }
        return teamPlayers.filter { $0.isInCurrentSeason }.sorted(by: { $0.order < $1.order })
    }
    
    func player(withId id: String) -> Player? {
        let state = App.core.state
        guard let currentTeam = state.teamState.currentTeam else { return nil }
        let teamPlayers = state.playerState.players(for: currentTeam)
        return teamPlayers.first(where: { $0.id == id })
    }
    
}
