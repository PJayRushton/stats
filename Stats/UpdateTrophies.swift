//
//  UpdateTrophies.swift
//  Stats
//
//  Created by Parker Rushton on 8/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct TrophySectionsUpdated: Event {
    
    var sections: [TrophySection]
    var gameId: String
    
    init(_ sections: [TrophySection], gameId: String) {
        self.sections = sections
        self.gameId = gameId
    }
    
}

struct UpdateTrophies: Command {
    
    var game: Game?
    
    init(for game: Game? = nil) {
        self.game = game
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        DispatchQueue.global().async {
            let objectId = self.game?.id ?? state.seasonState.currentSeasonId
            guard let id = objectId else { return }
            let sections = Trophy.allValues.compactMap { trophy -> TrophySection? in
                let trophyStats = state.statState.stats(for: id, ofType: trophy.statType)
                let isWorst = trophy == Trophy.worseBattingAverage
                let winners = self.winningStats(from: trophyStats, isWorst: isWorst)
                guard let winner = winners.first else { return nil }
                
                return TrophySection(trophy: trophy, firstStat: winner, secondStat: winners.second)
            }
            guard !sections.isEmpty else { return }
            core.fire(event: TrophySectionsUpdated(sections, gameId: id))
        }
    }
    
}


// MARK - Private

extension UpdateTrophies {
    
    func winningStats(from stats: [Stat], isWorst: Bool = false) -> (first: Stat?, second: Stat?) {
        guard !stats.isEmpty, let currentTeam = App.core.state.teamState.currentTeam else { return (nil, nil) }
        var allStats = isWorst ? stats.sorted() : stats.sorted().reversed()
        let winnerStat = allStats.removeFirst()
        guard winnerStat.value > 0 else { return (nil, nil) }
        guard stats.count > 1 else { return (winnerStat, nil) }
        
        var secondStat: Stat?
        
        if currentTeam.isCoed {
            var otherGenderStats = stats.filter { $0.player?.gender !=  winnerStat.player?.gender }
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
