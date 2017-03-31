//
//  GetCurrentUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct GetCurrentUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let userRecordId = state.userState.userRecordId else { return }
        let predicate = NSPredicate(format: "%K == %@", userRecordIdKey, userRecordId.recordName)
        cloudManager.fetchRecords(ofType: User.recordName, predicate: predicate) { records, error in
            if error == nil, let userRecord = records?.first, let user = try? User(record: userRecord) {
                core.fire(event: Selected<User>(user))
                core.fire(command: GetUserTeams())
            } else {
                core.fire(event: Selected<User>(nil))
            }
        }
    }
    
}
