//
//  SubscribeToTeam.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct SubscribeToTeam: Command {
    
    var teamId: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkAccess.teamsRef.child(teamId)
        networkAccess.unsubscribe(from: ref)
        
        networkAccess.subscribe(to: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                core.fire(event: Updated<Team>(team))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
