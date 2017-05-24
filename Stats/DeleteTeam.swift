//
//  DeleteTeam.swift
//  Stats
//
//  Created by Parker Rushton on 4/6/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

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
            switch result {
            case .success:
                self.networkAccess.unsubscribe(from: self.team.ref)
                core.fire(event: Delete<Team>(self.team))
                self.deleteTeamFromCurrentUser(core)
                self.deleteAllTheThings(core)
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func deleteTeamFromCurrentUser(_ core: Core<AppState>) {
        if var user = core.state.userState.currentUser {
            user.ownedTeamIds.remove(self.team.id)
            core.fire(command: UpdateObject(user))
        }
    }
    
    private func deleteAllTheThings(_ core: Core<AppState>) {
        let seasonsRef = StatsRefs.seasonsRef(teamId: team.id)
        let gamesRef = StatsRefs.gamesRef(teamId: team.id)
        let atBatsRef = StatsRefs.atBatsRef(teamId: team.id)
        let playersRef = StatsRefs.playersRef(teamId: team.id)
        
        for ref in [seasonsRef, gamesRef, atBatsRef, playersRef] {
            networkAccess.deleteObject(at: ref, completion: nil)
            networkAccess.unsubscribe(from: ref)
        }
        StatsRefs.teamImageStorageRef(teamId: self.team.id).delete(completion: nil)
    }
    
}
