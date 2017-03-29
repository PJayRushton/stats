//
//  NewUserState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import CloudKit

struct UsernameUpdated: Event {
    var username: String?
}
struct UsernameAvailabilityUpdated: Event {
    var isAvailable: Bool
}

struct EmailUpdated: Event {
    var email: String?
}

struct ICloudUserLoaded: Event {
    var recordID: CKRecordID
}

struct NewUserState: State {
    
    var userRecordID: CKRecordID?
    var username: String?
    var usernameIsAvailable = false
    var email: String?
    var avatar: UIImage?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ICloudUserLoaded:
            userRecordID = event.recordID
        case let event as UsernameUpdated:
            username = event.username
        case let event as UsernameAvailabilityUpdated:
            usernameIsAvailable = event.isAvailable
        case let event as EmailUpdated:
            email = event.email
        default:
            break
        }
    }
    
}
