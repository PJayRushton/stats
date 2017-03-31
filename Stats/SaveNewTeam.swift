//
//  SaveNewTeam.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveNewTeam: Command {
    
    var name: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkController.teamsRef.childByAutoId()
        let newTeam = Team(id: ref.key, name: name)
        networkController.updateObject(at: ref, parameters: newTeam.marshaled()) { result in
            if case .success = result {
                core.fire(command: AddTeamToUser(team: newTeam, type: .owned))
                core.fire(command: SubscribeToTeam(teamId: newTeam.id))
            }
        }
    }
    
}
