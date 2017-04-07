//
//  DeleteTeam.swift
//  Stats
//
//  Created by Parker Rushton on 4/6/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct Delete<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
}

struct DeleteTeam: Command {
    
    var team: Team
    
    init(_ team: Team) {
        self.team = team
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.deleteObject(at: team.ref) { result in
            if case .success = result {
                self.networkAccess.unsubscribe(from: self.team.ref)
                core.fire(event: Delete<Team>(self.team))
                
                // Delete team from user team lists
                if var user = state.userState.currentUser {
                    user.ownedTeamIds.remove(self.team.id)
                    core.fire(command: UpdateObject(object: user))
                }
                
                //Delete image
                StatsRefs.teamImageStorageRef(teamId: self.team.id).delete(completion: nil)
                // Delete players
                // Delete games
                // Delete Atbats
            }
        }
    }
    
}
