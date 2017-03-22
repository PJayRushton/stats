//
//  User.swift
//  TeacherTools
//
//  Created by Parker Rushton on 1/3/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import Firebase
import Marshal

struct User: Identifiable {
    
    var id: String
    var cloudKitId: String?
    var deviceId:  String
    var email: String?
    var username: String
    var avatarURLString: String?
    var creationDate: Date
    
    var ownedTeamIds = [String]()
    var managedTeamIds = [String]()
    var fanTeamIds = [String]()
    
    init(id: String = "", cloudKitId: String? = nil, deviceId: String = "", email: String? = nil, username: String = "newUser", avatarURLString: String? = nil) {
        self.id = id
        self.cloudKitId = cloudKitId
        self.deviceId = deviceId
        self.email = email
        self.username = username
        self.avatarURLString = avatarURLString
        self.creationDate = Date()
    }
    
}

extension User: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: "id")
        cloudKitId = try object.value(for: "iCloudId")
        deviceId = try object.value(for: "deviceId")
        email = try? object.value(for: "email")
        username = try object.value(for: "username")
        avatarURLString = try? object.value(for: "avatarURLString")
        creationDate = try object.value(for: "creationDate")
        
        let ownedTeamsDict: [String: String]? = try? object.value(for: "ownedTeamIds")
        ownedTeamIds = Array((ownedTeamsDict ?? [String: String]()).keys)
        
        let managedTeamsDict: [String: String]? = try? object.value(for: "managedTeamIds")
        ownedTeamIds = Array((managedTeamsDict ?? [String: String]()).keys)
        
        let fanTeamsDict: [String: String]? = try? object.value(for: "fanTeamIds")
        ownedTeamIds = Array((fanTeamsDict ?? [String: String]()).keys)
    }
    
}

extension User: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json["id"] = id
        json["iCloudId"] = cloudKitId
        json["deviceId"] = deviceId
        json["email"] = email
        json["username"] = username
        json["avatarURLString"] = avatarURLString
        json["creationDate"] = creationDate.iso8601String
        
        json["ownedTeamIds"] = ownedTeamIds.marshaled()
        json["managedTeamIds"] = managedTeamIds.marshaled()
        json["fanTeamIds"] = fanTeamIds.marshaled()
        
        return json
    }
    
}


extension User: Equatable { }

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}
