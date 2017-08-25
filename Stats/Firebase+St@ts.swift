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
    
    /// **/users/{userIdId}**
    static func userRef(id: String) -> DatabaseReference {
        return rootRef.child(usersRefKey).child(id)
    }
    
    /// **/seasons/{teamId}**
    static func seasonsRef(teamId: String) -> DatabaseReference {
        return rootRef.child(seasonsRefKey).child(teamId)
    }
    
    /// **/players/{teamId}**
    static func playersRef(teamId: String) -> DatabaseReference {
        return rootRef.child(playersRefKey).child(teamId)
    }
    
    /// **/games/{teamId}**
    static func gamesRef(teamId: String) -> DatabaseReference {
        return rootRef.child(gamesRefKey).child(teamId)
    }
    
    /// **/atBats/{teamId}**
    static func atBatsRef(teamId: String) -> DatabaseReference {
        return rootRef.child(atBatsRefKey).child(teamId)
    }
    
    /// **/stats/{teamId}*
    static func gameStatsRef(teamId: String) -> DatabaseReference {
        return rootRef.child(statsKey).child(teamId)
    }
    
    static func userAvatarStorageRef(userId id: String) -> StorageReference {
        return storageRef.child(avatarsKey).child(id)
    }
    
    static func teamImageStorageRef(teamId id: String) -> StorageReference {
        return storageRef.child(teamsRefKey).child(id)
    }

}
