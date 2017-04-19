//
//  GetUserTeams.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct GetUserTeams: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let user = state.userState.currentUser else { return }
//        let ids = user.allTeamIds
        
    }
    
}
