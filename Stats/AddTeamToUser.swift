//
//  AddTeamToUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

enum TeamOwnershipType {
    case owned
    case managed
    case fan
}

struct AddTeamToUser: Command {
    
    var teamRecordID: CKRecordID
    var type: TeamOwnershipType
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let currentUser = state.userState.currentUser else { return }
        
        let teamRef = CKReference(recordID: teamRecordID, action: CKReferenceAction.none)

        guard let userRecordId = currentUser.cloudKitRecordId else { return }
        cloudManager.fetchRecord(withID: userRecordId) { record, error in
            if error == nil, let record = record, let currentUser = state.userState.currentUser {
                switch self.type {
                case .owned:
                    var ownedTeamRefs = currentUser.ownedTeamRefs
                    ownedTeamRefs.append(teamRef)
                    record.setObject(ownedTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
                case .managed:
                    var managedTeamRefs = currentUser.managedTeamRefs
                    managedTeamRefs.append(teamRef)
                    record.setObject(managedTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
                case .fan:
                    var fanTeamRefs = currentUser.fanTeamRefs
                    fanTeamRefs.append(teamRef)
                    record.setObject(fanTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
                }
                self.cloudManager.saveRecord(record, completion: { record, error in
                    if error == nil, let record = record {
                        if let user = try? User(record: record) {
                            core.fire(event: Selected<User>(user))
                        }
                    } else {
                        // TODO:
                    }
                })
            }
        }
    }
    
}
