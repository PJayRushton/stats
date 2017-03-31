//
//  SubscriptionMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

var userIsSubscribed = false

struct SubscriptionMiddleware: Middleware {
    
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as Selected<User>:
            if let user = event.item {
                if !userIsSubscribed {
                    userIsSubscribed = true
                    App.core.fire(command: SubscribeToCurrentUser(id: user.id))
                    
                    user.alTeamIds.forEach({ (id) in
                        App.core.fire(command: SubscribeToTeam(teamId: id))
                    })
                }
            } else {
                userIsSubscribed = false
            }
        default:
            break
        }
    }
    
}
