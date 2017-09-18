//
//  MarkTeamStatsViewed.swift
//  Stats
//
//  Created by Parker Rushton on 9/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct MarkTeamStatsViewed: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var currentUser = state.userState.currentUser, let currentTeam = state.teamState.currentTeam else { return }
        currentUser.lastStatViewDates[currentTeam.id] = Date()
        core.fire(command: UpdateObject(currentUser))
    }
    
}
