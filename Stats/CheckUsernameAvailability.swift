//
//  CheckUsernameAvailability.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct CheckUsernameAvailability: Command {

    var username: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let predicate = NSPredicate(format: "username == %@", username)
        cloudManager.fetchRecords(ofType: String(describing: User.self), predicate: predicate) { records, error in
            if let records = records, !records.isEmpty {
                core.fire(event: UsernameAvailabilityUpdated(isAvailable: false))
            } else {
                core.fire(event: UsernameAvailabilityUpdated(isAvailable: true))
                core.fire(event: UsernameUpdated(username: self.username))
            }
        }
    }
    
}
