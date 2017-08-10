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
    var currentTrophySections = [TrophySection]()
    var playerStats = [Player: [Stat]]()
    var allStats: [Stat] {
        return Array(playerStats.values.joined())
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
            currentTrophySections = []
            playerStats = [:]
        case let event as StatGameUpdated:
            currentGame = event.game
        case let event as AtBatCountUpdated:
            atBatCount = event.count
        case let event as Updated<[Player: [Stat]]>:
            playerStats = event.payload
        case let event as Updated<[TrophySection]>:
            currentTrophySections = event.payload
        case let event as PlayerStatsUpdated:
            playerStats[event.player] = event.stats
        case let event as TeamObjectAdded<AtBat>:
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
        return allStats.filter { $0.type == type }
    }
}

struct AtBatCountUpdated: Event {
    var count = 0
}

struct StatGameUpdated: Event {
    var game: Game?
}
