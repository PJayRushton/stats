//
//  MigrateUsersToSeasons.swift
//  Stats
//
//  Created by Parker Rushton on 8/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct MigrateUsersToSeasons: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        DispatchQueue.global().async {
            state.teamState.allTeams.forEach { team in
                let teamPlayers = state.playerState.players(for: team)
                teamPlayers.forEach { player in
                    var updatedPlayer = player
                    updatedPlayer.seasons = [:]
                    state.seasonState.seasons(for: team).forEach { updatedPlayer.seasons[$0.id] = false }
                    
                    if let currentSeasonId = team.currentSeasonId {
                        updatedPlayer.seasons[currentSeasonId] = UserDefaults.standard.currentSeasonSubs.contains(updatedPlayer.id)
                    }
                    core.fire(command: SetObject(updatedPlayer))
                }
            }
        }
    }
    
}
