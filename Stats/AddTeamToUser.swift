//
//  AddTeamToUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum TeamOwnershipType {
    case owned
    case managed
    case fan
}

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
            currentUser.ownedTeamIds.append(team.id)
        case .managed:
            currentUser.managedTeamIds.append(team.id)
        case .fan:
            currentUser.managedTeamIds.append(team.id)
        }
        let ref = networkController.currentUserRef(id: currentUser.id)
        networkController.updateObject(at: ref, parameters: currentUser.marshaled(), completion: nil)
    }
    
}
