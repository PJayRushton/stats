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
    var creationDate: Date
    var email: String?
    var id: String
    var lastStatViewDates = [String: Date]()
    
    var ownedTeamIds = Set<String>()
    var managedTeamIds = Set<String>()
    var fanTeamIds = Set<String>()
    var currentTeamId: String?
    
    var allTeamIds: [String] {
        return [ownedTeamIds, managedTeamIds, fanTeamIds].flatMap { $0 }
    }
    
    init(id: String, avatarURLString: String? = nil, email: String? = nil, ownedTeamIds: [String] = [], managedTeamIds: [String] = [], fanTeamIds: [String] = []) {
        self.id = id
        self.avatarURLString = avatarURLString
        self.creationDate = Date()
        self.email = email
        
        self.ownedTeamIds = Set(ownedTeamIds)
        self.managedTeamIds = Set(managedTeamIds)
        self.fanTeamIds = Set(fanTeamIds)
    }

    init(object: MarshaledObject) throws {
        avatarURLString = try object.value(for: avatarKey)
        creationDate = try object.value(for: creationDateKey) ?? Date()
        email = try object.value(for: emailKey)
        id = try object.value(for: idKey)
        
        if let statViewDatesObject: [String: String] = try object.value(for: lastStatViewDatesKey) {
            statViewDatesObject.forEach { self.lastStatViewDates[$0.key] = $0.value.date }
        }
        
        if let ownedTeamsObject: JSONObject = try object.value(for: ownedTeamIdsKey) {
            ownedTeamIds = Set(ownedTeamsObject.keys)
        }
        if let managedTeamsObject: JSONObject = try object.value(for: managedTeamIdsKey) {
            managedTeamIds = Set(managedTeamsObject.keys)
        }
        if let fanTeamsObject: JSONObject = try object.value(for: fanTeamIdsKey) {
            fanTeamIds = Set(fanTeamsObject.keys)
        }
        currentTeamId = try object.value(for: currentTeamIdKey)
    }
    
    
    // MARK - Internal
    
    func statViewDate(forTeam teamId: String) -> Date? {
        return lastStatViewDates[teamId]
    }
    
    func isOwnerOrManager(of team: Team) -> Bool {
        return [ownedTeamIds, managedTeamIds].joined().contains(team.id)
    }
    
    func owns(_ team: Team) -> Bool {
        return ownedTeamIds.contains(team.id)
    }
    
}


// MARK: - Marshaling

extension User: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        var json = JSONObject()
        json[avatarKey] = avatarURLString
        json[creationDateKey] = creationDate.iso8601String
        json[idKey] = id
        json[emailKey] = email
        
        var datesObject = JSONObject()
        lastStatViewDates.forEach { datesObject[$0.key] = $0.value.iso8601String }
        json[lastStatViewDatesKey] = datesObject
        
        json[ownedTeamIdsKey] = ownedTeamIds.marshaled()
        json[managedTeamIdsKey] = managedTeamIds.marshaled()
        json[fanTeamIdsKey] = fanTeamIds.marshaled()
        json[currentTeamIdKey] = currentTeamId ?? NSNull()

        return json
    }
    
}

extension User {
    
    var ref: DatabaseReference {
        return StatsRefs.usersRef.child(id)
    }
    
}
