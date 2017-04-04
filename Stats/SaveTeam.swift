//
//  SaveTeam.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveTeam: Command {
    
    var team: Team
    
    func execute(state: AppState, core: Core<AppState>) {
        let isNew = team.id.isEmpty
        var updatedTeam = team
        
        var ref = networkAccess.teamsRef.child(team.id)
        if isNew {
            ref = networkAccess.teamsRef.childByAutoId()
            updatedTeam.id = ref.key
        }
        
        networkAccess.updateObject(at: ref, parameters: updatedTeam.marshaled()) { result in
            if case .success = result {
                core.fire(event: Selected<Team>(updatedTeam))
                
                if isNew {
                    core.fire(command: AddTeamToUser(team: updatedTeam, type: .owned))
                    core.fire(command: SubscribeToTeam(teamId: updatedTeam.id))
                }
            }
        }
    }
    
}
