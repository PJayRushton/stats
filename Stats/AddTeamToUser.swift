//
//  AddTeamToUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct AddTeamToUser: Command {
    
    var team: Team
    var type: TeamOwnershipType
    
    init(team: Team, type: TeamOwnershipType) {
        self.team = team
        self.type = type
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var currentUser = state.userState.currentUser else { return }
        switch type {
        case .owned:
            currentUser.ownedTeamIds.insert(team.id)
        case .managed:
            currentUser.managedTeamIds.insert(team.id)
        case .fan:
            currentUser.fanTeamIds.insert(team.id)
        }
        currentUser.currentTeamId = team.id
        core.fire(command: UpdateObject(currentUser))
    }
    
}
