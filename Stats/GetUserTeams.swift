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
        
        let currentUserTeamIds = [user.managedTeamRefs, user.ownedTeamRefs, user.fanTeamRefs].flatMap { $0 }.flatMap { $0.recordID.recordName }
        let predicate = NSPredicate(format: "self IN %@", currentUserTeamIds)
        cloudManager.fetchRecords(ofType: Team.recordName, predicate: predicate) { records, error in
            if error == nil, let records = records {
                let teams = records.flatMap({ try? Team(record: $0) })
                core.fire(event: Updated<[Team]>(teams))
            } else {
                core.fire(event: ErrorEvent(error: error, message: "Error retrieving your teams"))
            }
        }
    }
    
}
