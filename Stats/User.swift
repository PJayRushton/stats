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
    
    let ownedTeamRefs: [CKReference]
    let managedTeamRefs: [CKReference]
    let fanTeamRefs: [CKReference]

    var cloudKitRecordId: CKRecordID?
    
    init(cloudKitId: CKReference, username: String, avatar: CKAsset?, email: String?, ownedTeamIds: [CKReference], managedTeamIds: [CKReference], fanTeamIds: [CKReference]) {
        self.cloudKitId = cloudKitId
        self.username = username
        self.avatar = avatar
        self.email = email
        self.ownedTeamRefs = ownedTeamIds
        self.managedTeamRefs = managedTeamIds
        self.fanTeamRefs = fanTeamIds
    }

    required convenience init(record: CKRecord) throws {
        guard let cloudKitId = record.object(forKey: cloudKitIdKey) as? CKReference else { throw CloudKitError.keyNotFound(key: cloudKitIdKey) }
        guard let username = record.object(forKey: usernameKey) as? String else { throw CloudKitError.keyNotFound(key: usernameKey) }
        guard let ownedTeamsReferences = record.object(forKey: ownedTeamRefsKey) as? [CKReference] else { throw CloudKitError.keyNotFound(key: ownedTeamRefsKey) }
        guard let managedTeamsReferences = record.object(forKey: managedTeamRefsKey) as? [CKReference] else { throw CloudKitError.keyNotFound(key: managedTeamRefsKey) }
        guard let fanTeamsReferences = record.object(forKey: fanTeamRefsKey) as? [CKReference] else { throw CloudKitError.keyNotFound(key: fanTeamRefsKey) }

        let avatar = record.object(forKey: avatarKey) as? CKAsset
        let email = record.object(forKey: emailKey) as? String
        self.init(cloudKitId: cloudKitId, username: username, avatar: avatar, email: email, ownedTeamIds: ownedTeamsReferences, managedTeamIds: managedTeamsReferences, fanTeamIds: fanTeamsReferences)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: String(describing: User.self))
        setObject(user.cloudKitId, forKey: cloudKitIdKey)
        setObject(user.username as NSString, forKey: usernameKey)
        setObject(user.avatar, forKey: avatarKey)
        setObject(user.email as NSString?, forKey: emailKey)
        setObject(user.ownedTeamRefs as CKRecordValue?, forKey: ownedTeamRefsKey)
        setObject(user.managedTeamRefs as CKRecordValue?, forKey: managedTeamRefsKey)
        setObject(user.fanTeamRefs as CKRecordValue?, forKey: fanTeamRefsKey)
    }
    
}
