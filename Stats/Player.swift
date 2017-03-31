//
//  Player.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

enum Gender: String {
    case unspecified
    case male
    case female
}

struct Player: Identifiable, Unmarshaling {
    
    var id: String
    var gender: Gender
    var isSub: Bool
    var jerseyNumber: String?
    var name: String
    var phone: String?
    var teamId: String
    
    init(id: String = "", name: String, jerseyNumber: String?, isSub: Bool = false, phone: String? = nil, gender: Gender = .unspecified, teamId: String) {
        self.id = id
        self.name = name
        self.jerseyNumber = jerseyNumber
        self.isSub = isSub
        self.phone = phone
        self.gender = gender
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gender = try object.value(for: genderKey)
        isSub = try object.value(for: isSubKey)
        jerseyNumber = try object.value(for: jerseyNumberKey)
        name = try object.value(for: nameKey)
        phone = try object.value(for: phoneKey)
        teamId = try object.value(for: teamIdKey)
    }
    
}

extension Player: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[genderKey] = gender.rawValue
        json[isSubKey] = isSub
        json[jerseyNumberKey] = jerseyNumber
        json[nameKey] = name
        json[phoneKey] = phone
        json[teamIdKey] = teamId
        
        return json
    }
    
}
