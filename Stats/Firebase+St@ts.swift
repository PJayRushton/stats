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
        return storageRef.child(avatarsKey).child(id)
    }
    
    static func teamImageStorageRef(teamId id: String) -> FIRStorageReference {
        return storageRef.child(teamsRefKey).child(id)
    }

}

extension String {
    
    var statePlayer: Player? {
        let state = App.core.state
        guard let currentTeam = state.teamState.currentTeam else { return nil }
        let teamPlayers = state.playerState.players(for: currentTeam)
        return teamPlayers.first(where: { $0.id == self })
    }
    
}
