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
    var atBatCount = 0 {
        didSet {
            guard atBatCount != oldValue, atBatCount > 0 else { return }
            updateStatsIfNeeded()
        }
    }
    var currentTrophySections = [TrophySection]()
    var allStats = [StatType: [Stat]]()
    
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
            allStats = [:]
        case let event as AtBatCountUpdated:
            atBatCount = event.count
        case let event as TeamObjectAdded<AtBat>:
            updateStatsIfNeeded(with: event.object)
        case let event as TeamObjectChanged<AtBat>:
            updateStatsIfNeeded(with: event.object)
        case let event as TeamObjectRemoved<AtBat>:
            updateStatsIfNeeded(with: event.object)
        case let event as Updated<[StatType: [Stat]]>:
            allStats = event.payload
        case let event as Updated<[TrophySection]>:
            currentTrophySections = event.payload
        case let event as StatGameUpdated:
            currentGame = event.game
        default:
            break
        }
    }
    
    func updateStatsIfNeeded(with atBat: AtBat? = nil) {
        let state = App.core.state
        guard let currentTeam = state.teamState.currentTeam else { return }
        if let teamAtBats = state.atBatState.atBats(for: currentTeam), atBatCount > 0, teamAtBats.count >= atBatCount - 1 {
            App.core.fire(command: UpdateStats(after: atBat))
        }
    }
    
    func allStats(ofType type: StatType, from atBats: [AtBat]) -> [Stat] {
        let players = App.core.state.playerState.currentStatPlayers
        
        var playerStats = [Stat]()
        
        players.forEach { player in
            let playerAtBats = atBats.filter { $0.playerId == player.id }
            let statValue = type.statValue(from: playerAtBats)
            let playerStat = Stat(player: player, statType: type, value: statValue)
            playerStats.append(playerStat)
        }
        
        return playerStats.sorted(by: >)
    }
    
}

struct AtBatCountUpdated: Event {
    var count = 0
}

struct StatGameUpdated: Event {
    var game: Game?
}
