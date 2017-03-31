//
//  NetworkHelper.swift
//  Stats
//
//  Created by Parker Rushton on 3/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase

extension FirebaseNetworkAccess {
    
    /// **/users**
    var usersRef: FIRDatabaseReference {
        return rootRef.child(usersRefKey)
    }
    
    /// **/teams**
    var teamsRef: FIRDatabaseReference {
        return rootRef.child(teamsRefKey)
    }
    
    /// **/users/{userIdKEY}**
    func currentUserRef(id: String) -> FIRDatabaseReference {
        return rootRef.child(usersRefKey).child(id)
    }
    
    /// **/seasons/{teamKEY}**
    func seasonsRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(seasonsRefKey).child(teamId)
    }
    
    /// **/players/{teamKEY}**
    func playersRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(playersRefKey).child(teamId)
    }
    
    /// **/games/{teamKEY}**
    func gamesRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(gamesRefKey).child(teamId)
    }
    
    /// **/atBats/{teamId}**
    func atBatsRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child(atBatsRefKey).child(teamId)
    }
    
}
