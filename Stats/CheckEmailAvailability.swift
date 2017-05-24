//
//  CheckEmailAvailability.swift
//  Stats
//
//  Created by Parker Rushton on 5/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct CheckEmailAvailability: Command {
    
    var email: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.usersRef
        let query = ref.queryOrdered(byChild: emailKey).queryEqual(toValue: email)
        core.fire(event: Loading<NewUserState>(nil))

        networkAccess.getData(withQuery: query) { result in
            switch result {
            case .success:
                core.fire(event: EmailAvailabilityUpdated(isAvailable: false))
            case .failure:
                core.fire(event: EmailUpdated(email: self.email))
                core.fire(event: EmailAvailabilityUpdated(isAvailable: true))
            }
        }
    }
    
}
