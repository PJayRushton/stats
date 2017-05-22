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
                    self.addFakeDataAndSubscribe(core: core)
                }
            }
        }
    }
    
    fileprivate func addFakeDataAndSubscribe(core: Core<AppState>) {
        let dispatchGroup = DispatchGroup()
        let fakePlayerRef = StatsRefs.playersRef(teamId: team.id)
        let fakeGameRef = StatsRefs.gamesRef(teamId: team.id)
        let fakeAtBatRef = StatsRefs.atBatsRef(teamId: team.id)
        let refs = [fakePlayerRef, fakeGameRef, fakeAtBatRef]
        
        for ref in refs {
            dispatchGroup.enter()
            networkAccess.updateObject(at: ref, parameters: ["fake": true], completion: { result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    core.fire(event: ErrorEvent(error: error, message: nil))
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            core.fire(command: SubscribeToTeam(withId: self.team.id))
        }
    }
    
}
