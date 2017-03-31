//
//  UserState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct ICloudUserLoaded: Event {
    var id: String?
}

struct UserState: State {
    
    var iCloudId: String?
    var currentUser: User?
    var userIsLoaded = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ICloudUserLoaded:
            iCloudId = event.id
        case let event as Selected<User>:
            currentUser = event.item
            userIsLoaded = true
        default:
            break
        }
    }
    
}
