//
//  GetCurrentUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct GetCurrentUser: Command {
    
    var iCloudId: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.userRef(id: iCloudId)
        networkAccess.getData(at: ref) { result in
            let userResult = result.map(User.init)
            switch userResult {
            case let .success(user):
                core.fire(event: Selected<User>(user))
                core.fire(command: SubscribeToCurrentUser(id: user.id))
                
                user.allTeamIds.forEach { id in
                    core.fire(command: SubscribeToTeam(withId: id))
                }
                if user.allTeamIds.isEmpty {
                    core.fire(event: Subscribed<Team>(nil))
                }
            case let .failure(error):
                core.fire(event: Subscribed<Team>(nil))
                core.fire(event: Selected<User>(nil))
                core.fire(event: ErrorEvent(error: error, message: "Unable to find user with iCloudId: \(self.iCloudId)"))
            }
        }
    }
    
}
    
