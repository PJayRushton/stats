//
//  NetworkHelper.swift
//  Stats
//
//  Created by Parker Rushton on 3/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase

enum StatsRefs {
    
    static let rootRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
    /// **/users**
    static var usersRef: DatabaseReference {
        return rootRef.child(usersRefKey)
    }
    
    /// **/teams**
    static var teamsRef: DatabaseReference {
        return rootRef.child(teamsRefKey)
    }
    
    static var stockRef: DatabaseReference {
        return rootRef.child(stockKey)
    }
    
    /// **/users/{userIdKEY}**
    static func userRef(id: String) -> DatabaseReference {
        return rootRef.child(usersRefKey).child(id)
    }
    
    /// **/seasons/{teamKEY}**
    static func seasonsRef(teamId: String) -> DatabaseReference {
        return rootRef.child(seasonsRefKey).child(teamId)
    }
    
    /// **/players/{teamKEY}**
    static func playersRef(teamId: String) -> DatabaseReference {
        return rootRef.child(playersRefKey).child(teamId)
    }
    
    /// **/games/{teamKEY}**
    static func gamesRef(teamId: String) -> DatabaseReference {
        return rootRef.child(gamesRefKey).child(teamId)
    }
    
    /// **/atBats/{teamId}**
    static func atBatsRef(teamId: String) -> DatabaseReference {
        return rootRef.child(atBatsRefKey).child(teamId)
    }
    
    static func userAvatarStorageRef(userId id: String) -> StorageReference {
        return storageRef.child(avatarsKey).child(id)
    }
    
    static func teamImageStorageRef(teamId id: String) -> StorageReference {
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
