//
//  SubscriptionMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscriptionMiddleware: Middleware {
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as Selected<User>:
            if let user = event.item {
                if !state.userState.isSubscribed {
                    App.core.fire(command: SubscribeToCurrentUser(id: user.id))
                    
                    user.allTeamIds.forEach({ id in
                        App.core.fire(command: SubscribeToTeam(teamId: id))
                    })
                }
            }
        default:
            break
        }
    }
    
}
