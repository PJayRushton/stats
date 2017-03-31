//
//  Season.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Marshal

struct Season: Marshaling, Unmarshaling {
    
    var id: String
    var isCompleted: Bool
    var name: String
    var teamId: String
    
    init(id: String = "", isCompleted: Bool, name: String, teamId: String) {
        self.id = id
        self.isCompleted = isCompleted
        self.name = name
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        isCompleted = try object.value(for: isCompletedKey)
        name = try object.value(for: nameKey)
        team = try object.value(for: teamIdKey)
    }
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[isCompletedKey] = isCompletedKey
        json[nameKey] = name
        json[teamIdKey] = teamId
        
        return json
    }
    
}
