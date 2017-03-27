//
//  User.swift
//  TeacherTools
//
//  Created by Parker Rushton on 1/3/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import CloudKit

final class User: CloudKitSyncable {
    
    let cloudKitId: CKReference
    let username: String
    let avatar: CKAsset?
    let email: String?
    
    let ownedTeamIds: [CKReference]
    let managedTeamIds: [CKReference]
    let fanTeamIds: [CKReference]

    var cloudKitRecordId: CKRecordID?
    
    init(cloudKitId: CKReference, username: String, avatar: CKAsset?, email: String?, ownedTeamIds: [CKReference], managedTeamIds: [CKReference], fanTeamIds: [CKReference]) {
        self.cloudKitId = cloudKitId
        self.username = username
        self.avatar = avatar
        self.email = email
        self.ownedTeamIds = ownedTeamIds
        self.managedTeamIds = managedTeamIds
        self.fanTeamIds = fanTeamIds
    }

    required convenience init(record: CKRecord) throws {
        guard let cloudKitId = record.object(forKey: "cloudKitId") as? CKReference else { throw CloudKitError.keyNotFound(key: "cloudKitId") }
        guard let username = record.object(forKey: "username") as? String else { throw CloudKitError.keyNotFound(key: "username") }
        guard let ownedTeamsReferences = record.object(forKey: "ownedTeamIds") as? [CKReference] else { throw CloudKitError.keyNotFound(key: "ownedTeamIds") }
        guard let managedTeamsReferences = record.object(forKey: "managedTeamIds") as? [CKReference] else { throw CloudKitError.keyNotFound(key: "managedTeamIds") }
        guard let fanTeamsReferences = record.object(forKey: "fanTeamIds") as? [CKReference] else { throw CloudKitError.keyNotFound(key: "fanTeamIds") }

        let avatar = record.object(forKey: "avatar") as? CKAsset
        let email = record.object(forKey: "email") as? String
        self.init(cloudKitId: cloudKitId, username: username, avatar: avatar, email: email, ownedTeamIds: ownedTeamsReferences, managedTeamIds: managedTeamsReferences, fanTeamIds: fanTeamsReferences)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: String(describing: User.self))
        setObject(user.cloudKitId, forKey: "cloudKitId")
        setObject(user.username as NSString, forKey: "username")
        setObject(user.avatar, forKey: "avatar")
        setObject(user.email as NSString?, forKey: "email")
        setObject(user.ownedTeamIds as CKRecordValue?, forKey: "ownedTeamIds")
        setObject(user.managedTeamIds as CKRecordValue?, forKey: "managedTeamIds")
        setObject(user.fanTeamIds as CKRecordValue?, forKey: "fanTeamIds")
    }
    
}
