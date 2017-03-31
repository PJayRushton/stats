//
//  User.swift
//  TeacherTools
//
//  Created by Parker Rushton on 1/3/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import Marshal

struct User: Identifiable, Unmarshaling {
    
    var id: String
    var username: String
    var avatarURLString: String?
    var email: String?
    
    var ownedTeamIds: [String]
    var managedTeamIds: [String]
    var fanTeamIds: [String]
    
    init(id: String, username: String, avatarURLString: String? = nil, email: String? = nil, ownedTeamIds: [String] = [], managedTeamIds: [String] = [], fanTeamIds: [String] = []) {
        self.id = id
        self.username = username
        self.avatarURLString = avatarURLString
        self.email = email
        
        self.ownedTeamIds = ownedTeamIds
        self.managedTeamIds = managedTeamIds
        self.fanTeamIds = fanTeamIds
    }

    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        username = try object.value(for: usernameKey)
        avatarURLString = try? object.value(for: avatarKey)
        email = try? object.value(for: emailKey)
        
        let ownedTeamsObject: JSONObject? = try? object.value(for: ownedTeamIdsKey)
        ownedTeamIds = ownedTeamsObject != nil ? Array(ownedTeamsObject!.keys) : []
        
        let managedTeamsObject: JSONObject? = try? object.value(for: managedTeamIdsKey)
        managedTeamIds = managedTeamsObject != nil ? Array(managedTeamsObject!.keys) : []
        
        let fanTeamsObject: JSONObject? = try? object.value(for: fanTeamIdsKey)
        fanTeamIds = fanTeamsObject != nil ? Array(fanTeamsObject!.keys) : []
    }
    
    func isOwnerOrManager(of team: Team) -> Bool {
        return [ownedTeamIds, managedTeamIds].joined().contains(team.id)
    }
    
}

extension User: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[usernameKey] = username
        json[avatarKey] = avatarURLString
        json[emailKey] = email
        json[ownedTeamIdsKey] = ownedTeamIds.marshaled()
        json[managedTeamIdsKey] = managedTeamIds.marshaled()
        json[fanTeamIdsKey] = fanTeamIds.marshaled()
        
        return json
    }
}
