//
//  AppEvents.swift
//  Stats
//
//  Created by Parker Rushton on 9/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

// GameState

struct UpdateRecentlyCompletedGame: Event {
    var game: Game?
}

struct CalendarGames {
    var gamesToSave = [Game]()
    var gamesToEdit = [Game]()
    
    var hasSavableGames: Bool {
        return !gamesToSave.isEmpty || !gamesToEdit.isEmpty
    }
}


// MARK: - Generic

struct Selected<T>: Event {
    var item: T?
    
    init(_ item: T?) {
        self.item = item
    }
    
}

struct Subscribed<T: Identifiable>: Event {
    
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

struct ErrorEvent: Event {
    var error: Error?
    var message: String?
}


// MARK: - Team Events

struct TeamEntitiesUpdated<T>: Event {
    var teamId: String
    var entities: [T]
}

/**
 Generic event indicating that an object was added from Firebase and should be stored
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was added.
 - object:  The actual object that was added.
 */
struct TeamObjectAdded<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
}

/**
 Generic event indicating that an object was changed in Firebase and should be modified
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was changed.
 - object:  The actual object that was changed.
 */
struct TeamObjectChanged<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
}

/**
 Generic event indicating that an object was removed from Firebase and should be removed
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was removed.
 - object:  The actual object that was removed.
 */
struct TeamObjectRemoved<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
    
}

// ERROR

/**
 Generic event indicating that an object has an error when parsing from a Firebase event.
 The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that produced the error
 - error:   An optional error indicating the problem that occurred
 */
struct TeamObjectErrored: Event {
    var error: Error
    
    init(error: Error) {
        self.error = error
    }
    
}
