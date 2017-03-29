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
    var recordID: CKRecordID?
}

struct UserState: State {
    
    var userRecordId: CKRecordID?
    var currentUser: User?
    var userIsLoaded = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ICloudUserLoaded:
            userRecordId = event.recordID

        case let event as Selected<User>:
            currentUser = event.item
            userIsLoaded = true
        default:
            break
        }
    }
    
}
