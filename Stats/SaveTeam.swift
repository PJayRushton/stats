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
        networkAccess.updateObject(at: team.ref, parameters: team.marshaled()) { result in
            if case .success = result {
                core.fire(event: Selected<Team>(self.team))
                core.fire(command: AddTeamToUser(team: self.team, type: .owned))
                core.fire(command: SubscribeToObject(self.team))
            }
        }
    }
    
}
