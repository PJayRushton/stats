//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState(), middlewares: [SubscriptionMiddleware()])
}


struct AppState: State {
    
    var userState = UserState()
    var newUserState = NewUserState()
    var teamState = TeamState()
    var gameState = GameState()
    var seasonState = SeasonState()
    var playerState = PlayerState()
    var atBatState = AtBatState()
    
    mutating func react(to event: Event) {
        userState.react(to: event)
        newUserState.react(to: event)
        teamState.react(to: event)
        gameState.react(to: event)
        seasonState.react(to: event)
        playerState.react(to: event)
        atBatState.react(to: event)
    }
    
}

extension Command {
    
    var networkController: FirebaseNetworkAccess {
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
