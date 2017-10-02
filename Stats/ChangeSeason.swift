//
//  ChangeSeason.swift
//  Stats
//
//  Created by Parker Rushton on 8/8/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct ChangeSeason: Command {
    
    var newSeasonId: String
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var team = state.teamState.currentTeam else { return }
        let oldSeason = team.currentSeasonId
        team.currentSeasonId = newSeasonId
        core.fire(command: UpdateObject(team, completion: { success in
            if success {
                core.fire(command: SubscribeToAtBats(of: team.id, newSeasonId: self.newSeasonId, previousSeasonId: oldSeason))
            }
        }))
    }
    
}

