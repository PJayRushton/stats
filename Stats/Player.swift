//
//  Player.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase
import Marshal

struct Player: Identifiable, Unmarshaling {
    
    var id: String
    var gender: Gender
    var isSub: Bool
    var jerseyNumber: String?
    var name: String
    var order: Int
    var phone: String?
    var teamId: String
    
    var nameWithSub: String {
        guard isSub else { return name }
        return "\(name) (S)"
    }
    init(id: String = "", name: String, jerseyNumber: String? = nil, isSub: Bool = false, phone: String? = nil, gender: Gender = .unspecified, teamId: String) {
        self.id = id
        self.name = name
        self.jerseyNumber = jerseyNumber
        self.isSub = isSub
        self.phone = phone
        self.order = App.core.state.playerState.players(for: teamId).count
        self.gender = gender
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gender = try object.value(for: genderKey)
        isSub = try object.value(for: isSubKey)
        jerseyNumber = try object.value(for: jerseyNumberKey)
        name = try object.value(for: nameKey)
        order = try object.value(for: orderKey)
        phone = try object.value(for: phoneKey)
        teamId = try object.value(for: teamIdKey)
    }
    
    func stat(ofType type: StatType, from atBats: [AtBat]) -> Stat {
        return Stat(player: self, statType: type, value: type.statValue(from: atBats))
    }
    
    var hasCell: Bool {
        return phone != nil && phone!.isValidPhoneNumber
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
        json[orderKey] = order
        json[phoneKey] = phone
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension Player: Diffable {
    
    func isSame(as other: Player) -> Bool {
        return id == other.id &&
        gender == other.gender &&
        isSub == other.isSub &&
        jerseyNumber == other.jerseyNumber &&
        name.lowercased() == other.name.lowercased() &&
        phone == other.phone
    }
    
}


extension Player {
    
    var ref: DatabaseReference {
        return StatsRefs.playersRef(teamId: teamId).child(id)
    }
    
}
