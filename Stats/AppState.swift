//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState())
}


struct AppState: State {
    
    var currentMenuItem: HomeMenuItem?
    var userState = UserState()
    var newUserState = NewUserState()
    var teamState = TeamState()
    var newTeamState = NewTeamState()
    var gameState = GameState()
    var newGameState = NewGameState()
    var seasonState = SeasonState()
    var playerState = PlayerState()
    var atBatState = AtBatState()
    var statState = StatState()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<HomeMenuItem>:
            currentMenuItem = event.item
        default:
            break
        }
        
        userState.react(to: event)
        newUserState.react(to: event)
        teamState.react(to: event)
        newTeamState.react(to: event)
        gameState.react(to: event)
        newGameState.react(to: event)
        seasonState.react(to: event)
        playerState.react(to: event)
        atBatState.react(to: event)
        statState.react(to: event)
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

// ERROR

struct ErrorEvent: Event {
    var error: Error?
    var message: String?
}
