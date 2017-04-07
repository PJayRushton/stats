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
                    
                    // Fake player
                    let fakePlayer = Player(id: "fake", name: "fake", teamId: self.team.id)
                    self.networkAccess.updateObject(at: fakePlayer.ref, parameters: fakePlayer.marshaled(), completion: { result in
                        if case .success = result {
                            // Subscribe
                            core.fire(command: SubscribeToTeam(withId: self.team.id))
                        }
                    })
                }
            }
        }
    }
    
}
