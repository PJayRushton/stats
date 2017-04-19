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
                
                if let user = state.userState.currentUser, !user.allTeamIds.contains(self.team.id) {
                    core.fire(command: AddTeamToUser(team: self.team, type: .owned))
                    self.addFakeStuffAndSubscribe(core: core)
                }
            }
        }
    }
    
    fileprivate func addFakeStuffAndSubscribe(core: Core<AppState>) {
        let fakePlayerRef = StatsRefs.playersRef(teamId: team.id).childByAutoId()
        self.networkAccess.updateObject(at: fakePlayerRef, parameters: ["fake": true], completion: { result in
            switch result {
            case .success:
                self.addFakeGame(core: core)
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
                core.fire(command: SubscribeToTeam(withId: self.team.id))
            }
        })
    }
    
    fileprivate func addFakeGame(core: Core<AppState>) {
        let fakePlayerRef = StatsRefs.gamesRef(teamId: team.id)
        networkAccess.updateObject(at: fakePlayerRef, parameters: ["fake": true], completion: { result in
            core.fire(command: SubscribeToTeam(withId: self.team.id))
        })
    }

}
