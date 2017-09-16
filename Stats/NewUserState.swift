//
//  NewUserState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct NoOp: Event { }

struct EmailAvailabilityUpdated: Event {
    var isAvailable: Bool
}
struct EmailUpdated: Event {
    var email: String?
}

struct NewUserState: State {
    
    var email: String?
    var emailIsAvailable = false
    var isLoading = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as EmailUpdated:
            email = event.email
        case let event as EmailAvailabilityUpdated:
            emailIsAvailable = event.isAvailable
            isLoading = false
        case _ as Loading<NewUserState>:
            isLoading = true
        default:
            break
        }
    }
    
}
