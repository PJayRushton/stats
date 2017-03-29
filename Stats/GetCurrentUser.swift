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
    
    var userRecordId: CKRecordID
    
    func execute(state: AppState, core: Core<AppState>) {
        let predicate = NSPredicate(format: "cloudKitId == %@", userRecordId)
        cloudManager.fetchRecords(ofType: User.recordName, predicate: predicate) { records, error in
            if error == nil, let userRecord = records?.first, let user = try? User(record: userRecord) {
                core.fire(event: Selected<User>(user))
            } else {
                core.fire(event: Selected<User>(nil))
            }
        }
    }
    
}
