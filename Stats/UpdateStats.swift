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
    var game: Game?
    var stats: [Stat]
    
    init(for player: Player, game: Game? = nil, stats: [Stat]) {
        self.player = player
        self.game = game
        self.stats = stats
    }
}

struct TrophySectionsUpdated: Event {
    
    var sections: [TrophySection]
    var game: Game?
    
    init(_ sections: [TrophySection], game: Game? = nil) {
        self.sections = sections
        self.game = game
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


}


// MARK - Private

extension UpdateStats {
    
    func calculateStats(for player: Player? = nil, core: Core<AppState>) {
        DispatchQueue.global().async {
            let allPlayers = player != nil ? [player!] : core.state.playerState.currentStatPlayers
            
            let statGame = core.state.statState.currentGame
            allPlayers.forEach { player in
                let playerAtBats = core.state.atBatState.atBats(for: player, in: statGame)
                let stats = StatType.allValues.flatMap({ type -> Stat? in
                    let statValue = type.statValue(from: playerAtBats)
                    return Stat(player: player, type: type, value: statValue)
                })
                core.fire(event: PlayerStatsUpdated(for: player, game: statGame, stats: stats))
            }
            self.calculateTrophySections(core: core)
        }
    }
    
    func calculateTrophySections(core: Core<AppState>) {
        DispatchQueue.global().async {
            let statGame = core.state.statState.currentGame
            let sections = Trophy.allValues.flatMap { trophy -> TrophySection? in
                let trophyStats = core.state.statState.allStats(ofType: trophy.statType)
                let isWorst = trophy == Trophy.worseBattingAverage
                let winners = self.winningStats(from: trophyStats, isWorst: isWorst)
                guard let winner = winners.first else { return nil }
                
                return TrophySection(trophy: trophy, firstStat: winner, secondStat: winners.second)
            }
            guard !sections.isEmpty else { return }
            core.fire(event: TrophySectionsUpdated(sections, game: statGame))
        }
    }

    func winningStats(from stats: [Stat], isWorst: Bool = false) -> (first: Stat?, second: Stat?) {
        guard !stats.isEmpty, let currentTeam = App.core.state.teamState.currentTeam else { return (nil, nil) }
        var allStats = isWorst ? stats.sorted() : stats.sorted().reversed()
        let winnerStat = allStats.removeFirst()
        guard winnerStat.value > 0 else { return (nil, nil) }
        guard stats.count > 1 else { return (winnerStat, nil) }
        
        var secondStat: Stat?
        
        if currentTeam.isCoed {
            var otherGenderStats = stats.filter { $0.player.gender !=  winnerStat.player.gender }
            otherGenderStats = isWorst ? otherGenderStats.sorted() : otherGenderStats.sorted().reversed()
            secondStat = otherGenderStats.first
        } else {
            secondStat = allStats.first
        }
        if !isWorst {
            guard let second = secondStat, second.value > 0 else { return (winnerStat, nil) }
        }
        
        return (first: winnerStat, second: secondStat)
    }
    
}
