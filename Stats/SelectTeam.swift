//
//  SelectTeam.swift
//  Stats
//
//  Created by Parker Rushton on 9/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SelectTeam: Command {
    
    var team: Team
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var currentUser = state.userState.currentUser else { return }
        core.fire(command: UnsubscribeFromAtBats())
        currentUser.currentTeamId = team.id
        core.fire(command: UpdateObject(currentUser))
        core.fire(event: Selected<Team>(team))
    }
    
}
