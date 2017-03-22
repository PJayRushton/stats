//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState(), middlewares: [/*UserMiddleware()*/])
}


struct AppState: State {
    
    var currentUser: User?
    var currentICloudId: String?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<User>:
            currentUser = event.item
        case let event as ICloudUserIdentified:
            currentICloudId = event.iCloudId
        default:
            break
        }
    }
    
}

extension Command {
    
    var networkAccess: FirebaseNetworkAccess {
        return FirebaseNetworkAccess()
    }
}


// MARK: - Events

// GENERIC

struct Selected<T>: Event {
    var item: T?
    
    init(_ item: T?) {
        self.item = item
    }
    
}

struct Updated<T>: Event {
    var payload: T
    
    init(_ payload: T) {
        self.payload = payload
    }
    
}

struct ReachablilityChanged: Event {
    var reachable: Bool
}

// ERROR

struct ErrorEvent: Event {
    var error: Error?
    var message: String?
}
