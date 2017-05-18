//
//  NetworkHelper.swift
//  Stats
//
//  Created by Parker Rushton on 3/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase

enum StatsRefs {
    
    static let rootRef = FIRDatabase.database().reference()
    static let storageRef = FIRStorage.storage().reference()
    
    /// **/users**
    static var usersRef: FIRDatabaseReference {
        return rootRef.child(usersRefKey)
    }
    
    /// **/teams**
    static var teamsRef: FIRDatabaseReference {
        return rootRef.child(teamsRefKey)
    }
    
    static var quotesRef: FIRDatabaseReference {
        return rootRef.child(quotesKey)
    }
    static var stockRef: FIRDatabaseReference {
        return rootRef.child(stockKey)
    }
    
    /// **/users/{userIdKEY}**
    static func userRef(id: String) -> FIRDatabaseReference {
        return rootRef.child(usersRefKey).child(id)
    }
    
    /// **/seasons/{teamKEY}**
    static func seasonsRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(seasonsRefKey).child(teamId)
    }
    
    /// **/players/{teamKEY}**
    static func playersRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(playersRefKey).child(teamId)
    }
    
    /// **/games/{teamKEY}**
    static func gamesRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(gamesRefKey).child(teamId)
    }
    
    /// **/atBats/{teamId}**
    static func atBatsRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(atBatsRefKey).child(teamId)
    }
    
    static func userAvatarStorageRef(userId id: String) -> FIRStorageReference {
        return storageRef.child("avatars").child(id)
    }
    
    static func teamImageStorageRef(teamId id: String) -> FIRStorageReference {
        return storageRef.child("teams").child(id)
    }

}

extension String {
    
    var statePlayer: Player? {
        return App.core.state.playerState.allPlayers.first(where: { $0.id == self })
    }
}
