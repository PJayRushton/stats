//
//  CheckUsernameAvailability.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct CheckUsernameAvailability: Command {

    var username: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.usersRef
        let query = ref.queryOrdered(byChild: usernameKey).queryEqual(toValue: username)
        core.fire(event: Loading<NewUserState>(nil))
        
        networkAccess.getData(withQuery: query) { result in
            switch result {
            case .success:
                core.fire(event: UsernameAvailabilityUpdated(isAvailable: false))
            case .failure:
                core.fire(event: UsernameUpdated(username: self.username))
                core.fire(event: UsernameAvailabilityUpdated(isAvailable: true))
            }
        }
    }
    
}
