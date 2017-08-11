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
    var atBatCount = 0
    var allTrophySections = [TrophySection]()
    var playerStats = [Player: [Stat]]()
    var allStats: [Stat] {
        return Array(playerStats.values.joined())
    }
    var gameStats = [String: [Stat]]()
    var gameTrophySections = [String: [TrophySection]]()
    
    
    var currentTrophySections: [TrophySection] {
        if let statGame = currentGame, let sections = gameTrophySections[statGame.id] {
            return sections
        } else {
            return allTrophySections
        }
    }
    var currentStats: [Stat] {
        if let currentGame = currentGame, let gameStats = gameStats[currentGame.id] {
            return gameStats
        } else {
            return allStats
        }
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
            currentSeasonId = event.item?.currentSeasonId
            atBatCount = 0
            allTrophySections = []
            gameTrophySections = [:]
            playerStats = [:]
        case let event as StatGameUpdated:
            currentGame = event.game
        case let event as AtBatCountUpdated:
            atBatCount = event.count
            
        case let event as PlayerStatsUpdated:
            if let game = event.game {
                var currentGameStats = gameStats[game.id] ?? []
                currentGameStats = currentGameStats.filter { $0.player != event.player }
                currentGameStats.append(contentsOf: event.stats)
                gameStats[game.id] = currentGameStats
            } else {
                playerStats[event.player] = event.stats
            }
        case let event as TrophySectionsUpdated:
            if let game = event.game {
                gameTrophySections[game.id] = event.sections
            } else {
                allTrophySections = event.sections
            }
        case _ as TeamObjectAdded<AtBat>:
            if App.core.state.atBatState.atBats.count - 1 >= atBatCount {
                App.core.fire(command: UpdateStats())
            }
        default:
            break
        }
    }
    
    func updateStatsIfNeeded(with atBat: AtBat? = nil) {
        let state = App.core.state
        if case let teamAtBats = state.atBatState.atBats, atBatCount > 0, teamAtBats.count >= atBatCount - 1 {
            App.core.fire(command: UpdateStats())
        }
    }
    
    func allStats(ofType type: StatType) -> [Stat] {
        if let statGame = currentGame, let gameStats = gameStats[statGame.id] {
            return gameStats.filter { $0.type == type }
        } else {
            return allStats.filter { $0.type == type }
        }
    }
    
}

struct AtBatCountUpdated: Event {
    var count = 0
}

struct StatGameUpdated: Event {
    var game: Game?
}
