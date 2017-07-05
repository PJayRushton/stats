//
//  AtBatState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct AtBatState: State {
    
    var allAtBats = [String: [AtBat]]()
    var currentAtBat: AtBat?
    var currentResult = AtBatCode.single
    
    func atBats(for team: Team) -> [AtBat]? {
        return allAtBats[team.id]
    }
    
    func atBats(for game: Game) -> [AtBat] {
        guard let teamAtBats = allAtBats[game.teamId] else { return [] }
        return teamAtBats.filter { $0.gameId == game.id }
    }
    
    func atBats(for player: Player, in game: Game? = nil) -> [AtBat] {
        guard let teamAtBats = allAtBats[player.teamId] else { return [] }
        let playerABs = teamAtBats.filter { $0.playerId == player.id }
        guard let filteringGame = game else { return playerABs }
        return playerABs.filter { $0.gameId == filteringGame.id }
    }
    
    func atBats(for season: Season) -> [AtBat] {
        let all = allAtBats.flatMap { $0.value }
        return all.filter { $0.seasonId == season.id }
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamObjectAdded<AtBat>:
            var updatedTeamAtBats = allAtBats[event.teamId] ?? [AtBat]()
            updatedTeamAtBats.append(event.object)
            allAtBats[event.teamId] = updatedTeamAtBats
            
            guard let current = currentAtBat, current == event.object else { return }
            currentAtBat = current
            
        case let event as TeamObjectChanged<AtBat>:
            var updatedTeamAtBats = allAtBats[event.teamId] ?? [AtBat]()
            guard let index = updatedTeamAtBats.index(of: event.object) else { return }
            updatedTeamAtBats.remove(at: index)
            updatedTeamAtBats.append(event.object)
            allAtBats[event.teamId] = updatedTeamAtBats
            
            guard let current = currentAtBat, current == event.object else { return }
            currentAtBat = current
            
        case let event as TeamObjectRemoved<AtBat>:
            var updatedTeamAtBats = allAtBats[event.teamId] ?? [AtBat]()
            guard let index = updatedTeamAtBats.index(of: event.object) else { return }
            updatedTeamAtBats.remove(at: index)
            allAtBats[event.teamId] = updatedTeamAtBats
            
            guard let current = currentAtBat, current == event.object else { return }
            currentAtBat = nil
            
        case let event as Selected<AtBatCode>:
            currentResult = event.item ?? .single
        default:
            break
        }
    }
    
}
