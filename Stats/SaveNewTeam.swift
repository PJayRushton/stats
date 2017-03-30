//
//  SaveNewTeam.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct SaveNewTeam: Command {
    
    var name: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let team = Team(name: name, type: .slowPitch)
        let teamRecord = CKRecord(team: team)
        cloudManager.saveRecord(teamRecord) { record, error in
            if error == nil, let record = record {
                core.fire(event: Selected<Team>(team))
                core.fire(command: AddTeamToUser(teamRecordID: record.recordID, type: .owned))
            } else {
                core.fire(event: ErrorEvent(error: error, message: ""))
            }
        }
    }
    
}
