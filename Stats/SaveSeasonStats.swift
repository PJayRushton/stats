//
//  SaveSeasonStats.swift
//  Stats
//
//  Created by Parker Rushton on 7/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveSeasonStats: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        DispatchQueue.global().async {
            guard let currentTeam = state.teamState.currentTeam, let currentSeason = state.seasonState.currentSeason else { return }
            let allPlayers = state.playerState.currentPlayers(for: currentTeam.id)
            var seasonStats = GameStats(currentSeason)
            var stats = [String: [Stat]]()
            allPlayers.forEach { player in
                let statsForPlayer = state.statState.playerStats(for: player)
                stats[player.id] = statsForPlayer
            }
            let ref = StatsRefs.gameStatsRef(teamId: currentSeason.teamId).child(currentSeason.id)
            seasonStats.id = ref.key
            seasonStats.stats = stats
            self.networkAccess.setValue(at: ref, parameters: seasonStats.jsonObject())
        }
    }
    
}
