//
//  Season.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase
import Marshal

struct Season: Identifiable, Unmarshaling {
    
    var id: String
    var isCompleted: Bool
    var name: String
    var teamId: String
    
    init(id: String = "", isCompleted: Bool = false, name: String, teamId: String) {
        self.id = id
        self.isCompleted = isCompleted
        self.name = name
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        isCompleted = try object.value(for: isCompletedKey)
        name = try object.value(for: nameKey)
        teamId = try object.value(for: teamIdKey)
    }
    
}

extension Season: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[isCompletedKey] = isCompleted
        json[nameKey] = name
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension Season {
    
    var ref: DatabaseReference {
        return StatsRefs.seasonsRef(teamId: teamId).child(id)
    }
    
}
