//
//  StatState.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

// MARK: - Events

struct SubFilterUpdated: Event {
    var includeSubs: Bool
}

struct StatGameUpdated: Event {
    var game: Game?
}


struct StatState: State {
    
    var currentViewType = StatsViewType.trophies
    var includeSubs = false
    var currentGame: Game?
    var allStats = [String: GameStats]()
    var trophySections = [String: [TrophySection]]()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<StatsViewType>:
            currentViewType = event.payload
            
        case let event as SubFilterUpdated:
            includeSubs = event.includeSubs
            
        case let event as StatGameUpdated:
            currentGame = event.game
            
        case let event as Selected<Team>:
            currentViewType = .trophies
            currentGame = nil
            trophySections = [:]
            includeSubs = false
            guard let team = event.item else { return }
            clearStats(team.id)
            
        case let event as StatGameUpdated:
            currentGame = event.game
            
        case let event as TeamObjectAdded<GameStats>:
            allStats[event.object.gameId] = event.object
            
        case let event as TeamObjectChanged<GameStats>:
            allStats[event.object.gameId] = event.object
            
        case let event as TeamObjectRemoved<GameStats>:
            allStats[event.object.gameId] = nil
            
        case let event as TrophySectionsUpdated:
            trophySections[event.gameId] = event.sections
            
        default:
            break
        }
    }
    
    mutating func clearStats(_ teamId: String) {
        allStats.forEach { key, statsValue in
            if statsValue.teamId != teamId {
                self.allStats[key] = nil
            }
        }
    }
    
    var currentTrophies: [TrophySection] {
        if let statGame = currentGame, let sections = trophySections[statGame.id] {
            return sections
        } else if let currentSeasonId = App.core.state.seasonState.currentSeasonId, let sections = trophySections[currentSeasonId] {
            return sections
        }
        return []
    }
    var currentStats: GameStats? {
        if let currentGame = currentGame, case let gameStats = allStats[currentGame.id] {
            return gameStats
        } else if let currentSeasonId = App.core.state.seasonState.currentSeasonId, case let seasonStats = allStats[currentSeasonId] {
            return seasonStats
        }
        
        return nil
    }
    
    func stats(for id: String) -> GameStats? {
        return allStats[id]
    }
    
    /// Calculates the stats for the object id passsed in `Game.id` or `Season.id`
    ///
    /// - Parameters:
    ///   - id: Game.id or Season.id
    ///   - type: StatType of all the stats returned
    /// - Returns: Stats from the object passed in of the type passed in
    func stats(for id: String, ofType type: StatType) -> [Stat] {
        guard let stats = self.stats(for: id) else { return [] }
        return stats.allStats.filter { $0.type == type }.sorted(by: >)
    }
    
    func playerStats(for player: Player, game: Game? = nil) -> [Stat] {
        let playerAtBats = App.core.state.atBatState.atBats(for: player, in: game)
        return StatType.allValues.flatMap { type -> Stat? in
            let statValue = type.statValue(from: playerAtBats)
            return Stat(playerId: player.id, type: type, value: statValue)
        }
    }
    
}
