//
//  SubscribeToTeam.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscribeToTeam: Command {
    
    var teamId: String
    
    init(withId id: String) {
        self.teamId = id
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.teamsRef.child(teamId)
        
        networkAccess.subscribe(to: ref) { result in
            let objectResult = result.map(Team.init)
            switch objectResult {
            case let .success(parsedObject):
                core.fire(event: Updated(parsedObject))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
