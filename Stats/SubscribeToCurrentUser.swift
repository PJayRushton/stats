//
//  SubscribeToCurrentUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscribeToCurrentUser: Command {
    
    var id: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkController.currentUserRef(id: id)
        networkController.subscribe(to: ref) { result in
            let userResult = result.map(User.init)
            switch userResult {
            case let .success(user):
                core.fire(event: Selected<User>(user))
            case let .failure(error):
                core.fire(event: Selected<User>(nil))
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
