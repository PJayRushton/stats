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
        guard let userRecordID = currentUser.cloudKitRecordId else { return }
        
        let userRecord = CKRecord(recordType: User.recordName, recordID: userRecordID)
        userRecord.setObject(teamRef, forKey: recentTeamRefKey)
        
        switch self.type {
        case .owned:
            var ownedTeamRefs = currentUser.ownedTeamRefs
            ownedTeamRefs.append(teamRef)
            userRecord.setObject(ownedTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
        case .managed:
            var managedTeamRefs = currentUser.managedTeamRefs
            managedTeamRefs.append(teamRef)
            userRecord.setObject(managedTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
        case .fan:
            var fanTeamRefs = currentUser.fanTeamRefs
            fanTeamRefs.append(teamRef)
            userRecord.setObject(fanTeamRefs as CKRecordValue, forKey: ownedTeamRefsKey)
        }
        self.cloudManager.saveRecord(userRecord, completion: { record, error in
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
