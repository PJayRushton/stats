//
//  Team.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

enum TeamType: Int {
    case baseball
    case fastPitch
    case slowPitch
}


class Team: CloudKitSyncable {
    
    let image: CKAsset?
    let name: String
    let type: TeamType
    let shareCode: String
    let currentSeasonRef: CKReference

    var cloudKitRecordId: CKRecordID?
    
    
    // Accessors
    var imageURL: URL? {
        return image?.fileURL
    }
    
    init(currentSeasonRef: CKReference, image: CKAsset?, name: String, shareCode: String, type: TeamType) {
        self.currentSeasonRef = currentSeasonRef
        self.image = image
        self.name = name
        self.shareCode = shareCode
        self.type = type
    }
    
    required convenience init(record: CKRecord) throws {
        guard let currentSeasonRef = record.object(forKey: currentSeasonRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: currentSeasonRefKey) }
        let image = record.object(forKey: imageKey) as? CKAsset
        guard let name = record.object(forKey: nameKey) as? String else { throw CloudKitError.keyNotFound(key: nameKey) }
        guard let shareCode = record.object(forKey: shareCodeKey) as? String else { throw CloudKitError.keyNotFound(key: shareCodeKey) }
        guard let typeInt = record.object(forKey: typeKey) as? Int else { throw CloudKitError.keyNotFound(key: typeKey) }
        guard let type = TeamType(rawValue: typeInt) else { throw CloudKitError.parsingError(key: typeKey) }
        self.init(currentSeasonRef: currentSeasonRef, image: image, name: name, shareCode: shareCode, type: type)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(team: Team) {
        let recordId = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: team.recordType, recordID: recordId)
        self.setObject(team.currentSeasonRef, forKey: currentSeasonRefKey)
        self.setObject(team.image, forKey: imageKey)
        self.setObject(team.name as NSString, forKey: nameKey)
        self.setObject(recordId.recordName.last4 as NSString, forKey: shareCodeKey)
        self.setObject(NSNumber(value: team.type.rawValue), forKey: typeKey)
    }
    
}

/*
    let seasons: [CKReference]
    let players: [CKReference]
    let ownerIds: [CKReference]
    let managerIds: [CKReference]
    let fanIds: [CKReference]
*/
