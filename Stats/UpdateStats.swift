//
//  UpdateStats.swift
//  Stats
//
//  Created by Parker Rushton on 7/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct PlayerStatsUpdated: Event {
    
    var player: Player
    var stats: [Stat]
    
    init(for player: Player, stats: [Stat]) {
        self.player = player
        self.stats = stats
    }
}

struct UpdateStats: Command {
    
    var atBat: AtBat?
    
    init(after atBat: AtBat? = nil) {
        self.atBat = atBat
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        if let playerId = atBat?.playerId, let player = state.playerState.player(withId: playerId) {
            calculateStats(for: player, core: core)
        } else {
            calculateStats(core: core)
        }
        calculateTrophySections(core: core)
    }
    
    func calculateTrophySections(core: Core<AppState>) {
        DispatchQueue.global().async {
            let sections = Trophy.allValues.flatMap { trophy -> TrophySection? in
                let trophyStats = core.state.statState.allStats(ofType: trophy.statType)
                let isWorst = trophy == Trophy.worseBattingAverage
                let winners = self.winningStats(from: trophyStats, isWorst: isWorst)
                guard let winner = winners.first else { return nil }
                
                return TrophySection(trophy: trophy, firstStat: winner, secondStat: winners.second)
            }
            
            core.fire(event: Updated<[TrophySection]>(sections))
        }
    }

}


// MARK - Private

extension UpdateStats {
    
    func calculateStats(for player: Player? = nil, core: Core<AppState>) {
        DispatchQueue.global().async {
            let allPlayers = player != nil ? [player!] : core.state.playerState.currentStatPlayers
            
            allPlayers.forEach { player in
                let playerAtBats = App.core.state.atBatState.currentAtBats(for: player)
                let stats = StatType.allValues.flatMap({ type -> Stat? in
                    let statValue = type.statValue(from: playerAtBats)
                    return Stat(player: player, type: type, value: statValue)
                })
                core.fire(event: PlayerStatsUpdated(for: player, stats: stats))
            }
        }
    }

    func winningStats(from stats: [Stat], isWorst: Bool = false) -> (first: Stat?, second: Stat?) {
        guard !stats.isEmpty, let currentTeam = App.core.state.teamState.currentTeam else { return (nil, nil) }
        var allStats = isWorst ? stats.sorted() : stats.sorted().reversed()
        let winnerStat = allStats.removeFirst()
        guard winnerStat.value > 0 else { return (nil, nil) }
        guard stats.count > 1 else { return (winnerStat, nil) }
        
        let otherGender: Gender = winnerStat.player.gender == .male ? .female : .male
        let otherGenderStats = stats.filter { $0.player.gender == otherGender }
        let statsForSecond = currentTeam.isCoed ? otherGenderStats : allStats
        let secondStat = statsForSecond.first
        guard let second = secondStat, second.value > 0 else { return (winnerStat, nil) }
        return (first: winnerStat, second: second)
    }
    
}
