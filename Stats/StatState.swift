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
struct StatCSVPathUpdated: Event {
    var objectId: String
    var path: URL?
}
struct TrophyCSVPathUpdated: Event {
    var objectId: String
    var path: URL?
}



struct StatState: State {
    
    var currentViewType = StatsViewType.trophies
    var includeSubs = false
    var currentGame: Game?
    var allStats = Set<GameStats>()
    var trophySections = [String: [TrophySection]]()
    var statPaths = [String: URL]()
    var trophyPaths = [String: URL]()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<StatsViewType>:
            currentViewType = event.payload
            
        case let event as SubFilterUpdated:
            includeSubs = event.includeSubs
            
        case let event as StatGameUpdated:
            currentGame = event.game
            
        case _ as Selected<Team>:
            currentViewType = .trophies
            currentGame = nil
            includeSubs = false
            statPaths = [:]
            
        case let event as TeamObjectAdded<GameStats>:
            allStats.update(with: event.object)
            
        case let event as TeamObjectChanged<GameStats>:
            allStats.update(with: event.object)
            
        case let event as TeamObjectRemoved<GameStats>:
            allStats.remove(event.object)
            
        case let event as TrophySectionsUpdated:
            trophySections[event.gameId] = event.sections
            
        case let event as StatCSVPathUpdated:
            statPaths[event.objectId] = event.path
            
        case let event as TrophyCSVPathUpdated:
            trophyPaths[event.objectId] = event.path
            
        default:
            break
        }
    }
    
    mutating func clearStats(_ teamId: String) {
        allStats.forEach { stat in
            if stat.teamId == teamId {
                self.allStats.remove(stat)
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
        if let currentGame = currentGame, let gameStats = allStats.first(where: { $0.gameId == currentGame.id }) {
            return gameStats
        } else if let currentSeasonId = App.core.state.seasonState.currentSeasonId {
            return allStats.first(where: { $0.isSeason && $0.gameId == currentSeasonId })
        }
        
        return nil
    }
    var currentCSVPaths: [URL] {
        return [currentNumbersCSVPath, currentTrophyCSVPath].flatMap { $0 }
    }
    var currentNumbersCSVPath: URL? {
        guard let objectId = currentObjectId else { return nil }
        return statPaths[objectId]
    }
    var currentTrophyCSVPath: URL? {
        guard let objectId = currentObjectId else { return nil }
        return trophyPaths[objectId]
    }
    var currentObjectId: String? {
        return currentGame?.id ?? App.core.state.seasonState.currentSeasonId
    }
    var currentObjectIsGame: Bool {
        return currentGame != nil
    }
    var currentSeasonStats: GameStats? {
        guard let currentSeasonId = App.core.state.seasonState.currentSeasonId else { return nil }
        return stats(for: currentSeasonId)
    }
    func stats(for id: String) -> GameStats? {
        return allStats.first(where: { $0.gameId == id })
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
