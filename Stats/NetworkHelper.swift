//
//  NetworkHelper.swift
//  Stats
//
//  Created by Parker Rushton on 3/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase

let iCloudKey = "iCloudId"

extension FirebaseNetworkAccess {
    
    /// **/users**
    var usersRef: FIRDatabaseReference {
        return rootRef.child("users")
    }
    
    /// **/teams**
    var teamsRef: FIRDatabaseReference {
        return rootRef.child("teams")
    }
    
    /// **/players/{teamKEY}**
    func playersRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child("players").child(teamId)
    }
    
    /// **/games/{teamKEY}**
    func gamesRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child("games").child(teamId)
    }
    
    /// **/atBats/{teamId}**
    func atBatsRef(teamId: String) -> FIRDatabaseReference {
        return rootRef.child("atBats").child(teamId)
    }
    
}
