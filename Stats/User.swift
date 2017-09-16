//
//  User.swift
//  TeacherTools
//
//  Created by Parker Rushton on 1/3/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import Firebase
import Marshal

struct User: Identifiable, Unmarshaling {
    
    var avatarURLString: String?
    var email: String?
    var id: String
    var lastStatViewDate: Date?
    
    var ownedTeamIds = Set<String>()
    var managedTeamIds = Set<String>()
    var fanTeamIds = Set<String>()
    
    var allTeamIds: [String] {
        return [ownedTeamIds, managedTeamIds, fanTeamIds].flatMap { $0 }
    }
    
    init(id: String, avatarURLString: String? = nil, email: String? = nil, ownedTeamIds: [String] = [], managedTeamIds: [String] = [], fanTeamIds: [String] = []) {
        self.id = id
        self.avatarURLString = avatarURLString
        self.email = email
        
        self.ownedTeamIds = Set(ownedTeamIds)
        self.managedTeamIds = Set(managedTeamIds)
        self.fanTeamIds = Set(fanTeamIds)
    }

    init(object: MarshaledObject) throws {
        avatarURLString = try object.value(for: avatarKey)
        email = try object.value(for: emailKey)
        id = try object.value(for: idKey)
        lastStatViewDate = try object.value(for: lastStatViewDateKey)
        
        if let ownedTeamsObject: JSONObject = try object.value(for: ownedTeamIdsKey) {
            ownedTeamIds = Set(ownedTeamsObject.keys)
        }
        if let managedTeamsObject: JSONObject = try object.value(for: managedTeamIdsKey) {
            managedTeamIds = Set(managedTeamsObject.keys)
        }
        if let fanTeamsObject: JSONObject = try object.value(for: fanTeamIdsKey) {
            fanTeamIds = Set(fanTeamsObject.keys)
        }
    }
    
    
    // MARK - Internal
    
    func isOwnerOrManager(of team: Team) -> Bool {
        return [ownedTeamIds, managedTeamIds].joined().contains(team.id)
    }
    
    func owns(_ team: Team) -> Bool {
        return ownedTeamIds.contains(team.id)
    }
    
}


// MARK: - Marshaling

extension User: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[avatarKey] = avatarURLString
        json[idKey] = id
        json[emailKey] = email
        json[ownedTeamIdsKey] = ownedTeamIds.marshaled()
        json[managedTeamIdsKey] = managedTeamIds.marshaled()
        json[fanTeamIdsKey] = fanTeamIds.marshaled()
        
        return json
    }
    
}

extension User {
    
    var ref: DatabaseReference {
        return StatsRefs.usersRef.child(id)
    }
    
}
