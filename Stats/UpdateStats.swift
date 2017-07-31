//
//  UpdateStats.swift
//  Stats
//
//  Created by Parker Rushton on 7/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct UpdateStats: Command {
    
    var atBat: AtBat?
    
    init(after atBat: AtBat? = nil) {
        self.atBat = atBat
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let stats = currentTypeStats(from: state)
        core.fire(event: Updated<[StatType: [Stat]]>(stats))
        let sections = trophySections(from: state)
        core.fire(event: Updated<[TrophySection]>(sections))
    }
    
    func currentTypeStats(from state: AppState) -> [StatType: [Stat]] {
        var allStats = [StatType: [Stat]]()
        StatType.allValues.forEach { statType in
            let stats = state.statState.allStats(ofType: statType, from: state.currentAtBats)
            allStats[statType] = stats
        }
        return allStats
    }
    
    func trophySections(from state: AppState) -> [TrophySection] {
        let start = Date()
        let sections = Trophy.allValues.flatMap { trophy -> TrophySection? in
            let trophyStats = state.statState.allStats(ofType: trophy.statType, from: state.currentAtBats)
            let isWorst = trophy == Trophy.worseBattingAverage
            let winners = winningStats(from: trophyStats, isWorst: isWorst)
            guard let winner = winners.first else { return nil }
            
            return TrophySection(trophy: trophy, firstStat: winner, secondStat: winners.second)
        }
        let end = Date()
        let time = end.timeIntervalSince(start)
        print("Current Trophy Sections: -> \(time)")
        return sections
    }
    
    private func winningStats(from stats: [Stat], isWorst: Bool = false) -> (first: Stat?, second: Stat?) {
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
