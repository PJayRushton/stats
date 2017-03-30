//
//  Team.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit
import IGListKit

enum TeamType: String {
    case baseball
    case fastPitch
    case slowPitch
}


class Team: CloudKitSyncable {
    
    let image: CKAsset?
    let name: String
    let type: TeamType
    let shareCode: String
    let currentSeasonRef: CKReference?

    var cloudKitRecordId: CKRecordID?
    
    
    // Accessors
    var imageURL: URL? {
        return image?.fileURL
    }
    
    init(currentSeasonRef: CKReference? =  nil, image: CKAsset? = nil, name: String, shareCode: String = "", type: TeamType) {
        self.currentSeasonRef = currentSeasonRef
        self.image = image
        self.name = name
        self.shareCode = shareCode
        self.type = type
    }
    
    required convenience init(record: CKRecord) throws {
        let currentSeasonRef = record.object(forKey: currentSeasonRefKey) as? CKReference
        let image = record.object(forKey: imageKey) as? CKAsset
        guard let name = record.object(forKey: nameKey) as? String else { throw CloudKitError.keyNotFound(key: nameKey) }
        guard let shareCode = record.object(forKey: shareCodeKey) as? String else { throw CloudKitError.keyNotFound(key: shareCodeKey) }
        guard let typeString = record.object(forKey: typeKey) as? String else { throw CloudKitError.keyNotFound(key: typeKey) }
        guard let type = TeamType(rawValue: typeString) else { throw CloudKitError.parsingError(key: typeKey) }
        self.init(currentSeasonRef: currentSeasonRef, image: image, name: name, shareCode: shareCode, type: type)
        cloudKitRecordId = record.recordID
    }
    
}

extension Team: IGListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return cloudKitRecordId!
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? Team else { return false }
        return image == other.image &&
        name == other.name &&
        type == other.type &&
        currentSeasonRef == other.currentSeasonRef
    }
    
}

extension CKRecord {
    
    convenience init(team: Team) {
        let recordId = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Team.recordName, recordID: recordId)
        self.setObject(team.currentSeasonRef, forKey: currentSeasonRefKey)
        self.setObject(team.image, forKey: imageKey)
        self.setObject(team.name as NSString, forKey: nameKey)
        self.setObject(recordId.recordName.last4 as NSString, forKey: shareCodeKey)
        self.setObject(team.type.rawValue as NSString, forKey: typeKey)
    }
    
}

/*
    let seasons: [CKReference]
    let players: [CKReference]
    let ownerIds: [CKReference]
    let managerIds: [CKReference]
    let fanIds: [CKReference]
*/
