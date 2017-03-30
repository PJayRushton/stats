//
//  User.swift
//  TeacherTools
//
//  Created by Parker Rushton on 1/3/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import CloudKit

class User: CloudKitSyncable {
    
    let userRecordId: String
    let username: String
    let avatar: CKAsset?
    let email: String?
    
    var ownedTeamRefs: [CKReference]
    var managedTeamRefs: [CKReference]
    var fanTeamRefs: [CKReference]

    var cloudKitRecordId: CKRecordID?
    
    init(userRecordId: String, username: String, avatar: CKAsset?, email: String?, ownedTeamIds: [CKReference] = [], managedTeamIds: [CKReference] = [], fanTeamIds: [CKReference] = []) {
        self.userRecordId = userRecordId
        self.username = username
        self.avatar = avatar
        self.email = email
        self.ownedTeamRefs = ownedTeamIds
        self.managedTeamRefs = managedTeamIds
        self.fanTeamRefs = fanTeamIds
    }

    required convenience init(record: CKRecord) throws {
        guard let userRecordId = record.object(forKey: userRecordIdKey) as? String else { throw CloudKitError.keyNotFound(key: userRecordIdKey) }
        guard let username = record.object(forKey: usernameKey) as? String else { throw CloudKitError.keyNotFound(key: usernameKey) }
        let ownedTeamsReferences = record.object(forKey: ownedTeamRefsKey) as? [CKReference]
        let managedTeamsReferences = record.object(forKey: managedTeamRefsKey) as? [CKReference]
        let fanTeamsReferences = record.object(forKey: fanTeamRefsKey) as? [CKReference]
        
        let avatar = record.object(forKey: avatarKey) as? CKAsset
        let email = record.object(forKey: emailKey) as? String
        self.init(userRecordId: userRecordId, username: username, avatar: avatar, email: email, ownedTeamIds: ownedTeamsReferences ?? [], managedTeamIds: managedTeamsReferences ?? [], fanTeamIds: fanTeamsReferences ?? [])
        cloudKitRecordId = record.recordID
    }
    
    func isOwnerOrManager(of team: Team) -> Bool {
        guard let teamId = team.cloudKitRecordId else { return false }
        return ownedTeamRefs.map { $0.recordID }.contains(teamId) || managedTeamRefs.map { $0.recordID }.contains(teamId)
    }
    
}

extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: User.recordName)
        setObject(user.userRecordId as NSString, forKey: userRecordIdKey)
        setObject(user.username as NSString, forKey: usernameKey)
        setObject(user.avatar, forKey: avatarKey)
        setObject(user.email as NSString?, forKey: emailKey)
        setObject(user.ownedTeamRefs as CKRecordValue?, forKey: ownedTeamRefsKey)
        setObject(user.managedTeamRefs as CKRecordValue?, forKey: managedTeamRefsKey)
        setObject(user.fanTeamRefs as CKRecordValue?, forKey: fanTeamRefsKey)
    }
    
}
