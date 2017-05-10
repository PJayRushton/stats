//
//  NewUserState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct NoOp: Event { }
struct UsernameUpdated: Event {
    var username: String?
}
struct UsernameAvailabilityUpdated: Event {
    var isAvailable: Bool
}
struct IsCheckingUsername: Event { }
struct EmailUpdated: Event {
    var email: String?
}

struct NewUserState: State {
    
    var username: String?
    var usernameIsAvailable = false
    var isLoading = false
    var email: String?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as UsernameUpdated:
            username = event.username
        case _ as IsCheckingUsername:
            isLoading = true
        case let event as UsernameAvailabilityUpdated:
            usernameIsAvailable = event.isAvailable
            isLoading = false
        case let event as EmailUpdated:
            email = event.email
        default:
            break
        }
    }
    
}
