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
    var iCloudQueried = false
    var currentUser: User?
    var isLoaded = false
    var isSubscribed = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ICloudUserLoaded:
            iCloudId = event.id
            iCloudQueried = true
        case let event as Selected<User>:
            currentUser = event.item
            isLoaded = true
        case let event as Subscribed<User>:
            isSubscribed = event.item != nil
            isLoaded = true
        default:
            break
        }
    }
    
}
