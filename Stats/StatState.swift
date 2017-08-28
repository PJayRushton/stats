//
//  StatState.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubFilterUpdated: Event {
    var includeSubs: Bool
}

struct StatState: State {
    
    var currentViewType = StatsViewType.trophies
    var currentStatType = StatType.battingAverage
    var includeSubs = false
    var currentGame: Game?
    var currentSeasonId: String?
    var allTrophySections = [TrophySection]()
    var seasonStats: GameStats?
    var gameStats = [String: GameStats]()
    var gameTrophySections = [String: [TrophySection]]()
    
    var currentTrophySections: [TrophySection] {
        if let statGame = currentGame, let sections = gameTrophySections[statGame.id] {
            return sections
        } else {
            return allTrophySections
        }
    }
    var currentStats: GameStats? {
        if let currentGame = currentGame {
            return gameStats[currentGame.id]
        } else if let seasonStats = seasonStats {
            return seasonStats
        }
        
        return nil
    }
 
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<StatsViewType>:
            currentViewType = event.payload
        case let event as Updated<StatType>:
            currentStatType = event.payload
        case let event as SubFilterUpdated:
            includeSubs = event.includeSubs
        case let event as StatGameUpdated:
            currentGame = event.game
        case let event as Selected<Season>:
            currentSeasonId = event.item?.id
            
        case let event as Selected<Team>:
            currentGame = nil
            allTrophySections = []
            gameTrophySections = [:]
            seasonStats = nil
            currentSeasonId = event.item?.currentSeasonId
            
        case let event as StatGameUpdated:
            currentGame = event.game
            
        case let event as TeamObjectAdded<GameStats>:
            let eventStats = event.object
            if eventStats.isSeason, eventStats.gameId == App.core.state.seasonState.currentSeasonId {
                seasonStats = eventStats
            } else {
                gameStats[eventStats.gameId] = eventStats
            }
            
        case let event as TeamObjectChanged<GameStats>:
            let eventStats = event.object
            if eventStats.isSeason, eventStats.gameId == App.core.state.seasonState.currentSeasonId {
                seasonStats = eventStats
            } else {
                gameStats[eventStats.gameId] = eventStats
            }
            
        case let event as TeamObjectRemoved<GameStats>:
            let eventStats = event.object
            if eventStats.isSeason, eventStats.gameId == App.core.state.seasonState.currentSeasonId {
                seasonStats = nil
            } else {
                gameStats[eventStats.gameId] = nil
            }
            
        case let event as TrophySectionsUpdated:
            if let game = event.game {
                gameTrophySections[game.id] = event.sections
            } else {
                allTrophySections = event.sections
            }
            
        default:
            break
        }
    }
    
    func stats(for game: Game) -> GameStats? {
        return gameStats[game.id]
    }
    
    func stats(for game: Game, ofType type: StatType) -> [Stat] {
        guard let stats = stats(for: game) else { return [] }
        return stats.allStats.filter { $0.type == type }.sorted(by: >)
    }
    
    func allStats(ofType type: StatType) -> [Stat] {
        if let statGame = currentGame, let gameStats = stats(for: statGame) {
            return gameStats.allStats.filter { $0.type == type }
        } else if let seasonStats = seasonStats {
            return seasonStats.allStats.filter { $0.type == type }
        } else {
            return []
        }
    }
    
    func playerStats(for player: Player, game: Game) -> [Stat] {
        let playerAtBats = App.core.state.atBatState.atBats(for: player, in: game)
        return StatType.allValues.flatMap { type -> Stat? in
            let statValue = type.statValue(from: playerAtBats)
            return Stat(playerId: player.id, type: type, value: statValue)
        }
    }
    
}

struct StatGameUpdated: Event {
    var game: Game?
}
